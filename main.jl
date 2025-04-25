include("structs.jl")
using Plots, Measures, Images

red = RGB(0.9,0.1,0.1)#ideal
orange = RGB(0.8,.45,0.1)#good
yellow = RGB(0.75,0.7,0.1)#tolerated
blue = RGB(0.25,0.25,0.75)#deadly
plotsdir = "intermediate/plots/"
#plotkeys = [ (:Temperature, :RelativeHumidity), (:LightStrength, :Photoperiod), (:LightStrength, :Photoperiod)]
function rectangle!(vert1,vert2; kwargs...)
    plot!(Shape([vert1[1], vert2[1], vert2[1], vert1[1]], [vert1[2], vert1[2], vert2[2], vert2[2]]); kwargs...)
end

function properitalics(stringtext)
    index = findfirst(isequal('('), stringtext)#TODO: this won't work if you start doing weird stuff with the scientific name or use this for something else.
    if !isnothing(index)
        return "\\textit{"*stringtext[1:index-1]*"} "*stringtext[index:end]
    else
        return "\\textit{"*stringtext*"}"
    end
end

function makeplots(plant,data)
    #PLOT 1
    datax = data.Temperature
    datay = data.RelativeHumidity
    xlim = (45.0, 110.0)
    ylim = (0, 100)
    p1=plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Temperature (F)" , ylabel = "Relative Humidity (%)")
    rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
    rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
    rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
    plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :+)
    #savefig(plotsdir*plant*"_1.png")
    #PLOT 2
    datax = data.LightStrength
    datay = data.Photoperiod
    xlim = (0, 10.0)
    ylim = (0, 24)
    p2=plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Light Strength" , ylabel = "Photoperiod (h)")
    rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
    rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
    rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
    plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :+)
    #savefig(plotsdir*plant*"_2.png")
    #PLOT 3
    datax = data.Retention
    datay = data.Aeration
    xlim = (0, 10.0)
    ylim = (0, 10.0)
    p3=plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Soil Water Retention" , ylabel = "Soil Aeration")
    rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
    rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
    rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
    plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :+)
    #savefig(plotsdir*plant*"_3.png")
    #PLOT 4
    datax = data.pH
    datay = data.OrganicContent
    xlim = (3, 11.0)
    ylim = (0, 100.0)
    p4=plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Soil pH" , ylabel = "Soil Organic Content (%)")
    rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
    rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
    rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
    plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :+)
    #savefig(plotsdir*plant*"_4.png")

    plot(p1,p2,p3,p4, layout = 4, margin = 3mm)
    savefig(plotsdir*plant*".png")
end

function makelatex(key, data)
    commonname = data.CommonName
    scientificname = properitalics(data.ScientificName)# "\\textit{Aeonium arboreum}"
    infotext = data.Info
    soiltext  = data.SoilDescription
    caretext = data.CareDescription

    
    # 1. Generate LaTeX code
    latex_code = """
    \\documentclass{article}
    \\usepackage{graphicx} % Required for inserting images
    \\usepackage{geometry}
    \\usepackage{titlesec}
    \\pagestyle{empty}

    \\titleformat{\\section}[block]{\\normalfont\\Large\\bfseries}{\\thesection}{1em}{}
    \\titleformat{\\subsection}[block]{\\normalfont\\Large}{\\thesubsection}{2em}{} % Adds indentation
    \\begin{document}

    \\begin{center}
    {\\fontsize{36}{24}\\selectfont \\textbf{$commonname}} \\\\
    {\\fontsize{18}{24}\\selectfont $scientificname} \\\\
    \\vspace{30pt}
    {\\fontsize{20}{24}\\selectfont Care instructions}\\\\
    \\vspace{30pt} 
    \\includegraphics[width=1.0\\textwidth]{intermediate/croppedimages/$key.jpg}
    \\end{center}

    \\newgeometry{top=20mm, bottom=30mm, left=20mm, right=20mm}
    \\newpage

    \\section*{Info}
    $infotext

    \\section*{Environmental Considerations}
    \\subsection*{Soil}
    $soiltext
    \\subsection*{Upkeep}
    $caretext
    \\newline \\newline \\newline
    \\includegraphics[width=.9\\textwidth]{intermediate/plots/$key.png}

    \\end{document}
    """

    # 2. Write to a .tex file
    texfile = "intermediate/temp.tex"
    open(texfile, "w") do f
        write(f, latex_code)
    end

    # 3. Compile LaTeX (must have pdflatex or lualatex installed)
    run(`pdflatex --job-name=intermediate/$key $texfile`)
    mv("intermediate/$key.pdf","output/$key.pdf", force = true)
end

function cropimage(imagelocation, imagename, aspect) #aspect ratio width/height
    image = load(imagelocation*imagename)
    dims = size(image)
    oldaspect = dims[1]/dims[2]
    height = 0.0
    width = 0.0
    if oldaspect > aspect
        height = dims[2]
        width = aspect*height
    else
        width = dims[1]
        height = width/aspect
    end
    cuthoriz = Int64(round((dims[1] - width)/2))
    cutvert = Int64(round((dims[2] - height)/2))
    Images.save("intermediate/croppedimages/"*imagename,image[(cuthoriz+1):end-cuthoriz,(cutvert+1):end-cutvert])
end

function cropimages()
    subdirs = readdir("input/images/")
    ndirs = length(subdirs)
    for i = 1:1:ndirs
        cropimage("input/images/",subdirs[i], 1.0) #aspect ratio width/height
        println("Cropped $i / $ndirs")
    end
end

function generatePDF()
    filename = "input/plantinfo.json"  # Make sure the JSON file is named correctly
    all_plant_data = load_plant_data(filename)
    cropimages()
    for (plant, data) in all_plant_data
        makeplots(plant,data)
        makelatex(plant,data)
    end

end

# vars you want to include
