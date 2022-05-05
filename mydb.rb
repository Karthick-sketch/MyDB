load "DML.rb"

isDBSelected = false; dml = ddl = nil
while (true)
    print("MyDb>")
    ip = gets.chomp.downcase
    if (ip == "exit")
        break
    elsif (ip == "show databases")
        dir = (%x{ cd databases; ls -d */ }).delete("/").split("\n")
        Table::table(dir.map { |d| [d] })
    elsif (ip == "show tables")
        if (isDBSelected)
            tables = (%x{ cd databases/#{dml.getDatabase()}; ls *.csv }).split("\n")
            Table::table(tables.map { |d| [d.slice(0, d.index("."))] })
        else
            puts("Database was not selected")
        end
    else
        ip = ip.split
        if (ip.first == "use")
            if (File.directory?("databases/#{ip.last}"))
                dml = DML.new(ip.last)
                ddl = DML.new(ip.last)
                isDBSelected = true
            else
                puts("There is no database called #{ip.last}")
            end
        elsif (ip.first == 'create')
            if (ip[1] == 'database')
                system("mkdir databases/#{ip.last}")
            elsif (ip[1] == "table")
                if (isDBSelected)
                    ddl.create(ip[2], ip.slice(3, ip.size-1))
                else
                    puts("Database was not selected")
                end
            end
        elsif (ip.first == 'insert')
            if (isDBSelected)
                if (ip[1] == "into" and ip[3] == "values")
                    dml.insert(ip[2], ip.slice(4, ip.size-1))
                else
                    puts("Invalid syntax")
                end
            else
                puts("Database was not selected")
            end
        elsif (ip.first == 'update')
            # update mcu set movie = shang-chi_and_the_legend_of_the_ten_rings where id = 25
            if (isDBSelected)
                if (ip[2] == 'set' and ip[4] == '=')
                    dml.update(ip[1], ip[3], ip[5], ip[7], ip.last)
                else
                    puts("Invalid syntax")
                end
            else
                puts("Database was not selected")
            end
        elsif (ip.first == 'select')
            if (isDBSelected)
                order_by = ((ip[-3] == "order" and ip[-2] == "by") ? ip.last : "")
                index = ip.index("where")
                refName = compare = refValue = nil 
                if (not index.nil?)
                    refName = ip[index+1]
                    compare = ip[index+2]
                    refValue = ip[index+3]
                end
                dml.select(ip[ip.index("from")+1], ip.slice(1, ip.index("from")-1), order_by, refName, compare, refValue)
            else
                puts("Database was not selected")
            end
        else
            puts("Invalid syntax")
        end
    end
end

# select * from mcu order by timeline
