using DMARCParser
using Documenter

DocMeta.setdocmeta!(DMARCParser, :DocTestSetup, :(using DMARCParser); recursive=true)

makedocs(;
    modules=[DMARCParser],
    authors="Ross Armstrong",
    repo="https://github.com/analyticsinmotion/DMARCParser.jl/blob/{commit}{path}#{line}",
    sitename="DMARCParser.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://analyticsinmotion.github.io/DMARCParser.jl",
        edit_link="main",
        assets=String[],
        repolink="https://github.com/analyticsinmotion/DMARCParser.jl",
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/analyticsinmotion/DMARCParser.jl",
    devbranch="main",
)
