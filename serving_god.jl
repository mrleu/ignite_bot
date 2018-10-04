using Dates
using JSON
using StatsBase

USHERS = ["alex_leu", "eunice_wang", "cary_xing",
          "victoria_pai", "howard_wong", "gigi_hsu",
          "anthony_manalo"
]
PRAYERS = ["anthony_manalo", "alex_leu", "petrina_cheng",
           "christina_cheng", "eunice_wang", "dan_chan",
           "gigi_hsu", "alex_tat", "jason_wang",
           "jon_gauss"
]

function get_ushers(served, num_ushers=2)
    println("Usher")
    served_ushers = sort(StatsBase.countmap(served), byvalue=true)
    println("Served Frequency")
    println(served_ushers)
    serving_ushers = collect(keys(served_ushers))[1:num_ushers]
    return serving_ushers
end

function get_prayers(served, ushers, num_prayers=2)
    println("Prayer")
    served_prayers = sort(StatsBase.countmap(served), byvalue=true)
    println("Served Frequency")
    println(served_prayers)
    # delete ushers
    for usher in ushers
        served_prayers_ = delete!(served_prayers, usher)
    end
    serving_prayers = collect(keys(served_prayers))[1:num_prayers]
    return serving_prayers
end

function write_result(result, date)
    if !("output" in readdir())
        mkdir("output")
    end
    date_f = replace(date, "-" => "_")
    jsonify = JSON.json(result)
    open(string("output/serving_", date_f, ".json"), "w") do f
        write(f, jsonify)
    end
end

function served()
    served_p = PRAYERS
    served_u = USHERS
    if ("output" in readdir())
        for logf in readdir("output")
           parsed_f = JSON.parse(JSON.parsefile(string("output/",logf)))
            print(parsed_f["prayers"])
            served_p = append!(served_p, parsed_f["prayers"])
            served_u = append!(served_u, parsed_f["ushers"])
        end
    end
    return served_p, served_u
end

function get_coming_sunday()
    is_sunday = x -> Dates.dayofweek(x) == Dates.Sunday
    return string(Dates.tonext(is_sunday, Dates.today()))
end

function main()
    println("USHERBOT 2.0")
    coming_sunday = get_coming_sunday()
    served_p, served_u = served()
    println("For Ignite Service ", coming_sunday)
    ushers = get_ushers(served_u)
    println("Serving Ushers:", ushers)
    prayers = get_prayers(served_p, ushers)
    println("Serving Prayers:", prayers)
    result = Dict("prayers" => prayers, "ushers" => ushers)
    write_result(JSON.json(result), coming_sunday)
end
main()
