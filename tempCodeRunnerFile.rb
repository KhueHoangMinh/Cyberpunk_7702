def loadrank
        Thread.new {
            geturl = HOST + '/getdata'
            res = HTTParty.get(geturl)
            res = JSON.parse(res.body)
            @num_of_records = res.length
            if(@num_of_records > 5)
                count = 5
            else
                count = @num_of_records
            end
            rank = Array.new
            for i in 0..count-1
                rank << Record.new(res[i]["username"], res[i]["bestscore"])
            end
            @rank = rank
        }
    end