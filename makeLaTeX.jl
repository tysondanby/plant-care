include("structs.jl")
using Plots, Measures

red = RGB(0.9,0.1,0.1)#ideal
orange = RGB(0.8,.45,0.1)#good
yellow = RGB(0.75,0.7,0.1)#tolerated
blue = RGB(0.25,0.25,0.75)#deadly
plotsdir = "intermediate/plots/"
#plotkeys = [ (:Temperature, :RelativeHumidity), (:LightStrength, :Photoperiod), (:LightStrength, :Photoperiod)]
function rectangle!(vert1,vert2; kwargs...)
    plot!(Shape([vert1[1], vert2[1], vert2[1], vert1[1]], [vert1[2], vert1[2], vert2[2], vert2[2]]); kwargs...)
end

function generatePDF()
    filename = "plantinfo.json"  # Make sure the JSON file is named correctly
    all_plant_data = load_plant_data(filename)
    for (plant, data) in all_plant_data
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
end

# vars you want to include
key = "AeoniumZwartkop"
commonname = "Aeonium Zwartkop"
scientificname = "\\textit{Aeonium arboreum}"
infotext = "This section is not yet implemented. It must be added to the .json, updated in structs.jl to match, and then added."
soiltext  = "Light, fast-draining potting mix with added perlite"
caretext = "Keep soil slightly moist; moderate humidity; fertilize monthly"
# 1. Generate LaTeX code
latex_code = """
\\documentclass{article}
\\usepackage{graphicx} % Required for inserting images
\\usepackage{geometry}
\\usepackage{titlesec}

\\titleformat{\\section}[block]{\\normalfont\\Large\\bfseries}{\\thesection}{1em}{}
\\titleformat{\\subsection}[block]{\\normalfont\\Large}{\\thesubsection}{2em}{} % Adds indentation
\\begin{document}

\\begin{center}
    {\\fontsize{36}{24}\\selectfont \\textbf{$commonname}} \\\\
    {\\fontsize{18}{24}\\selectfont $scientificname} \\\\
    \\vspace{30pt}
    {\\fontsize{20}{24}\\selectfont Care instructions}\\\\
    \\vspace{30pt} 
    \\includegraphics[width=1.0\\textwidth]{images/$key.jpg}
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
run(`pdflatex $texfile`)