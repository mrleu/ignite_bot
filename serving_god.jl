using Dates
using JSON
using StatsBase

ushers = ["alex_leu", "eunice_wang", "cary_xing",
          "victoria_pai", "howard_wong", "gigi_hsu",
          "anthony_manalo"
]
prayers = ["anthony_manalo", "alex_leu", "petrina_cheng",
           "christina_cheng", "eunice_wang", "dan_chan",
           "gigi_hsu", "alex_tat", "jason_wang",
           "jon_gauss"
]

function get_ushers(num_ushers=2)
    # input on served data
    # xxx needs to pick up csv
    served = ["alex", "eunice", "cary", "victoria", "alex", "eunice", "victoria"]
    served_ushers = sort(StatsBase.countmap(vcat(served, ushers)), byvalue=true)
    serving_ushers = collect(keys(served_ushers))[1:num_ushers]
    return serving_ushers
end

function get_prayers(ushers, num_prayers=2)
    # input on served data
    served = ["anthony_manalo", "alex_leu", "petrina_cheng",
               "jon_gauss"
    ]
    served_prayers = sort(StatsBase.countmap(vcat(served, prayers)), byvalue=true)
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

function main()
    is_sunday = x -> Dates.dayofweek(x) == Dates.Sunday
    coming_sunday = string(Dates.tonext(is_sunday, Dates.today()))
    println("For Ignite Service ", coming_sunday)
    ushers = get_ushers()
    println("Serving Ushers:", ushers, "\n")
    prayers = get_prayers(ushers)
    println("Serving Prayers:", prayers)
    result = Dict("prayers" => prayers,
                  "ushers" => ushers
    )
    write_result(JSON.json(result), coming_sunday)
end

main()
