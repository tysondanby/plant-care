include("structs.jl")
using Plots

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
        xlim = (20.0, 120.0)
        ylim = (0, 100)
        plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Temperature (F)" , ylabel = "Relative Humidity (%)")
        rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
        rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
        rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
        plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :square)
        savefig(plotsdir*plant*"_1.png")
        #PLOT 2
        datax = data.LightStrength
        datay = data.Photoperiod
        xlim = (0, 10.0)
        ylim = (0, 24)
        plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Light Strength" , ylabel = "Photoperiod (h)")
        rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
        rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
        rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
        plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :square)
        savefig(plotsdir*plant*"_2.png")
        #PLOT 3
        datax = data.Retention
        datay = data.Aeration
        xlim = (0, 10.0)
        ylim = (0, 10.0)
        plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Soil Water Retention" , ylabel = "Soil Aeration")
        rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
        rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
        rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
        plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :square)
        savefig(plotsdir*plant*"_3.png")
        #PLOT 4
        datax = data.pH
        datay = data.OrganicContent
        xlim = (3, 11.0)
        ylim = (0, 100.0)
        plot([],[]; xlims = xlim, ylims = ylim, legend=false, xlabel = "Soil pH" , ylabel = "Soil Organic Content (%)")
        rectangle!((xlim[1],ylim[1]),(xlim[2],ylim[2]); color = blue, alpha = 0.5)
        rectangle!((datax.DeathLow,datay.DeathLow),(datax.DeathHigh,datay.DeathHigh); color = yellow, alpha = 0.5)
        rectangle!((datax.TooLow,datay.TooLow),(datax.TooHigh,datay.TooHigh); color = orange, alpha = 0.5)
        plot!([datax.Ideal], [datay.Ideal], seriestype=:scatter; color = red, markersize = 10, markershape= :square)
        savefig(plotsdir*plant*"_4.png")
    end
end