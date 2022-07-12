const supported_packages = [:DataFrames, :NamedArrays, :Plots, :HypothesisTests, :CSVFiles]

# Generic fallback
orgshow(io::IO, Any, i; kwargs...) = show(io, i)
orgshow(io::IO, ::MIME"text/org", i; kwargs...) = show(io, i)
# Overload types
orgshow(io::IO, ::MIME"text/org", t::Tuple; kwargs...) = print(io, join(t, ','))
orgshow(io::IO, ::MIME"text/org", ::Nothing; kwargs...) = print(io, "")
orgshow(io::IO, ::MIME"text/org", a::Array{T,1}; kwargs...) where T <: Any = print(io, join(a, '\n'))

# You can override this with a better one that uses some available module
function orgshow(io::IO, ::MIME"text/html", i::Array{T,2}; kwargs...) where T <: Any
    width = get(Dict(kwargs), :width, "100")
    print(io, """<table style="width:$width%">""")
    content = eachrow(i) |> x -> string("<tr>",
                                        join([string("<th>", join(l, "</th><th>"))
                                       for l in x], "</tr><tr>"))
    print(io, content, "</table>")
end

function orgshow(io::IO, ::MIME"text/org", i::Array{T,2}; kwargs...) where T <: Any
    out = eachrow(i) |> x -> join([join(l, ',') for l in x], '\n')
    print(io, out)
end

function orgshow(io::IO, ::MIME"text/csv", i::Array{T,2}; kwargs...) where T <: Any
    orgshow(io, MIME("text/org"), i; kwargs...)
end

function orgstring(e::Tuple{Exception,Any})
    string("ERROR,", e[1], "\n",
           "Stacktrace:\n",
           join(e[2], '\n'))
end

# The comma is needed to allow export as table
function orgshow(io::IO, ::MIME"text/org", e::Tuple{Exception,Any};
                 kwargs...)
    print(io, orgstring(e))
end

function orgshow(io::IO, ::MIME"text/org", t::NamedTuple)
    print(io, join(string.(keys(t)), ','))
    println(io)
    print(io, join(t, ','))
end

function orgshow(io::IO, ::MIME"text/org",
                          ta::Vector{<:NamedTuple})
    "This assume keys are the same. A better NamedTuple export is provided by
             the DataFrames (DataFrame(ta))"
    length(ta) <= 0 && return ""
    println(io, join(keys(first(ta)), ','))
    for t in ta
        print(io, join(string.(values(t)), ','))
        println(io)
    end
end

OrgAPApvalue(p) = p < 0.001 ? "< .001" : string("= ", round(p, sigdigits = 2))

function define_HypothesisTests()
    Main.@eval function orgshow(io::IO,
                                m::MIME"text/org",
                                test::PowerDivergenceTest; kwargs...)
        println(io, join(["test", "df", "N", "stat", "p-value"], ','))
        print(io, join(["X^2", test.df, test.n, test.stat, pvalue(test)], ','))
    end
    Main.@eval function orgshow(io::IO,
                                m::MIME"text/html",
                                test::PowerDivergenceTest; kwargs...)
        print(io, string("X^2",
                         " (", test.df, ", N = ", test.n,
                         ") = ",
                         round(test.stat; digits = 2),
                         ", p ", OrgAPApvalue(pvalue(test))))
    end
end

function define_Plots()
    # Fallback: we will try to plot any image/png or image/svg
    Main.@eval function orgshow(io::IO,
                                m::MIME"image/png",
                                any; kwargs...)
        show(io, MIME("image/png"), plot(any; kwargs...))
    end
    Main.@eval function orgshow(io::IO,
                                m::MIME"image/svg+xml",
                                any; kwargs...)
        show(io, MIME("image/svg+xml"), plot(any; kwargs...))
    end
    Main.@eval function orgshow(io::IO,
                                m::MIME"image/png",
                                p::Plots.Plot; kwargs...)
        show(io, MIME("image/png"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"image/png", e::Tuple{Exception,Any};
                                kwargs...)
        let p = plot(showaxis = false, grid = false, bg = :yellow)
            annotate!([0.5], [0.5], (orgstring(e), :red))
            orgshow(io, MIME("image/png"), p; kwargs...)
        end
    end
    Main.@eval function orgshow(io::IO, ::MIME"image/svg+xml", e::Exception; kwargs...)
        let p = plot(showaxis = false, grid = false, bg = :yellow)
            annotate!([0.5], [0.5], (string("ERROR: ", e), :red))
            orgshow(io, MIME("image/svg+xml"), p; kwargs...)
        end
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/html", p::Plots.Plot; kwargs...)
        p = plot(p; kwargs...)
        p.attr[:html_output_format] = "png"
        # Plots._show(io::IO, MIME("text/html"), p::Plots.Plot; kwargs...)
        Plots._show(io, MIME("text/html"), p)
    end
    Main.@eval function orgshow(io::IO, ::MIME"image/svg+xml", p::Plots.Plot; kwargs...)
        show(io, MIME("image/svg+xml"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"application/pdf", p::Plots.Plot; kwargs...)
        # ps, eps, tex or pdf. I think extra packages are required for all but pdf
        show(io, MIME("application/pdf"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"application/postscript", p::Plots.Plot; kwargs...)
        show(io, MIME("application/postscript"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"image/eps", p::Plots.Plot;
                                kwargs...)
        show(io, MIME("image/eps"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"application/x-tex", p::Plots.Plot;
                                kwargs...)
        show(io, MIME("application/x-tex"), plot(p; kwargs...))
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/org", p::Plots.Plot; kwargs...)
        # png or svg
        p.attr[:html_output_format] = "png"
        orgshow(io::IO, MIME("text/html"), p::Plots.Plot; kwargs...)
    end
end

function define_DataFrames()
    Main.@eval function orgshow(io::IO, ::MIME"text/csv", d::DataFrames.DataFrame)
        orgshow(io, MIME("text/org"), d)
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/org", d::DataFrames.DataFrame)
        out = join(string.(names(d)), ',') * '\n'
        out *= join([join(x, ',') for x in eachrow(d) .|> collect],'\n')
        print(io, out)
    end
end

function define_CSVFiles()
    Main.@eval function orgshow(io::IO, ::MIME"text/csv", d::CSVFiles.CSVFile)
        orgshow(io, MIME("text/org"), d)
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/html", d::CSVFiles.CSVFile)
        show(io, MIME("text/html"), RES)
    end
    Main.@eval function orgshow(io::IO, ::MIME"application/json", d::CSVFiles.CSVFile)
        show(io, MIME("application/vnd.dataresource+json"), RES)
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/org", d::CSVFiles.CSVFile)
        orgshow(io, MIME("text/org"), collect(d))
    end
end

function define_NamedArrays()
    Main.@eval function orgshow(io::IO, ::MIME"text/org",
                                 na::NamedArray{T,2} where T <: Any)
        n = names(na)
        a = collect(na)
        # The char used by NamedArrays is '╲' but by default it's not
        # shown in pdf export
        print(io, join(string.(na.dimnames), " \\ ") * ',')
        print(io, join(n[2], ',') * '\n')
        print(io, join([join([string(n[1][i], ','),
                              join([a[i,j]
                                    for j in 1:size(na,2)
                                    ], ',')])
                        for i in 1:size(na,1)
                        ], '\n'))
    end
    Main.@eval function orgshow(io::IO, ::MIME"text/org", na::NamedArray{T,1} where T <: Any)
        n = names(na)
        a = collect(na)
        print(io, string(na.dimnames[1], ',', '\n'))
        print(io, join([join([n[1][i], a[i]], ',')
                        for i in 1:length(n[1])], '\n'))
    end
end

define_package_functions(pkg::Symbol) = (@eval $pkg)()

function OrgBabelImport(imports; forced = false)
    "Load dependencies. Do this before calling OrgBabelReload()"
    # Reload this module, so that if new packages have been imported,
    # we can use them to save the output
    !forced && isempty(imports) && return
    println("$imports")
    try
        Main.eval(Meta.parse(
            """begin
                   $imports
               end"""))
        true
    catch e
        @show e
    end
end

function OrgBabelReload()
    "Defines show method based on loaded packages"
    for pkg in supported_packages
        if isdefined(Main, pkg) && (isa(getfield(Main, pkg), Module) ||
                                    isa(getfield(Main, pkg), UnionAll))
            define_package_functions(Symbol("define_", pkg))
            # Remove loaded packages from list to prevent multiple execution
            filter!(x -> x != pkg, supported_packages)
        end
    end
end

const Mimes = Dict(:org => "text/org",
                   :csv => "text/csv",
                   :png => "image/png",
                   :svg => "image/svg+xml",
                   :pdf => "application/pdf",
                   :html => "text/html",
                   :auto => "text/org",
                   :ps => "application/postscript",
                   :eps => "image/eps",
                   :tex => "application/x-tex")
                   
function OrgBabelFormat(output_type::Symbol,
                        output_file,                      
                        dir, vars_file,
                        src_file,
                        silently::Bool,
                        pure::Bool,
                        kwargs)
    content = read(src_file, String)
    vars = read(vars_file, String)
    # Fake a prompt with the current input
    try
        printstyled(IOContext(stdout, :color => true),
                    "\njulia> ", color = :blue)
        println(content)
    catch
    end
    # Dispatch on output type
    code = pure ? "let $vars; $content; end" : "begin $vars; $content;\n end"
    if output_type == :value
        # Run the code
        result = cd(expanduser(dir)) do
            try
                Main.eval(Meta.parse(code))
            catch e
                (e, stacktrace())
            end
        end
        if !silently
            try
                display(MIME("text/plain"), result)
            catch e
                println("Error $e while showing results")
            end
        end
        # Decide output type.
        # If the output has an extension, use it.
        # else, use the exporter format. Fallback to text/org
        output_ext = replace(splitext(output_file)[2], "." => "")
        required_format = isempty(output_ext) ? :auto : Symbol(output_ext)
        mime = get(Mimes, required_format, "text/org")
        temporary_output = IOBuffer()
        # Output directly to org (no :file, -> save to output_file)
        try
            orgshow(temporary_output,
                    MIME(mime), result; Base.eval(Meta.parse(kwargs))...)
        catch e
            @error "Probable ob-julia error! Please report to the author!"
            @error "Error: $e"
            print(temporary_output,
                  "Probable ob-julia error! Please report to the author!",
                  "Error: $e")
        end
        write(output_file, take!(temporary_output))
    elseif output_type == :output
        temporary_output_file = tempname()
        open(temporary_output_file, create = true, write = true) do f
            redirect_stdout(f) do
                redirect_stderr(f) do
                    cd(expanduser(dir)) do
                        try
                            Main.eval(Meta.parse(code))
                        catch e
                            println(e)
                            println(join(stacktrace(), '\n'))
                        end
                    end
                end
            end
        end
        if !silently
            # It's stupid to write and read it but I don't know how to
            # save redirect_stdout to IOBuffer or similar
            print(read(temporary_output_file, String))
        end
        mv(temporary_output_file, output_file, force = true)
    else
        "ERROR: invalid ouput type"
    end
    return nothing
end

OrgBabelReload()

