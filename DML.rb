load 'DDL.rb'

class DML < DDL
    def initialize(db)
        super(db)
    end

    def insert(tableName, attributes)
        fileName = getFileName(tableName)
        if (File.file?(fileName))
            file = File.open(fileName, "r")
            content = decryption(file.read())
            file.close()

            File.open(fileName, "w") do |file|
                file.syswrite(encryption(content + "\n" + attributes.join(",")))
            end
        else
            puts("#{tableName} table is not exists")
        end
    end

    def update(tableName, columnName, newData, refName, refValue)
        fileName = getFileName(tableName)
        if (File.file?(fileName))
            file = File.open(fileName, "r")
            contents = decryption(file.read()).split("\n")
            file.close()

            contents.each_with_index do |c, i|
                contents[i] = c.split(",")
            end

            head = contents.first
            title = head.index(refName); index = nil
            contents.each_with_index do |c, i|
                if (i != 0 and c[title] == refValue)
                    index = i; break
                end
            end

            unless index.nil?
                content = contents[index]
                content[head.index(columnName)] = newData
                contents[index] = content
                
                contents.each_with_index do |c, i|
                    contents[i] = c.join(',')
                end

                File.open(fileName, "w") do |file|
                    file.syswrite(encryption(contents.join("\n")))
                end
            else
                puts("syntax error")
            end
        else
            puts("#{tableName} table is not exists")
        end
    end

    def delete(tableName, columnName, compare, value)
        deleteColumns = where(tableName, columnName, compare, value)
        if deleteColumns.size > 1
            fileName = getFileName(tableName)
            file = File.open(fileName, "r")
            contents = decryption(file.read()).downcase.split("\n")
            file.close()

            contents.each_with_index do |c, i|
                contents[i] = c.split(",")
            end

            deleteColumns.shift()
            deleteColumns.each do |dc|
                contents.delete(dc)
            end

            contents.each_with_index do |c, i|
                contents[i] = c.join(',')
            end

            File.open(fileName, "w") do |file|
                file.syswrite(encryption(contents.join("\n")))
            end
        end
    end

    def select(tableName, cols, order_by, refName, compare, refValue)
        contents = where(tableName, refName, compare, refValue)
        unless contents.nil?
            colNum = []
            unless (cols.first == "*")
                contents.each_with_index do |content, i|
                    if (colNum.empty?)
                        colNum = cols.map { |c| content.index(c) }
                    end
                    contents[i] = colNum.map { |c| content[c] }
                end
            end
            Table::tableBody(orderBy(contents, order_by))
        end
    end

    def where(tableName, refName, compare, refValue)
        contents = nil
        fileName = getFileName(tableName)
        if (File.file?(fileName))
            file = File.open(fileName, "r")
            contents = decryption(file.read()).downcase.split("\n")
            file.close()
            contents.each_with_index do |c, i|
                contents[i] = c.split(",")
            end

            unless refName.nil? and compare.nil? and refValue.nil?
                head = contents.first; title = head.index(refName);
                contents = contents.slice(1, contents.size-1)
                case compare
                when "like"
                    contents = contents.filter { |content| content[title].include?(refValue) }
                when "="
                    contents = contents.filter { |content| content[title] == refValue }
                when "!="
                    contents = contents.filter { |content| content[title] != refValue }
                when "<="
                    contents = contents.filter { |content| content[title] <= refValue }
                when ">="
                    contents = contents.filter { |content| content[title] >= refValue }
                when "<"
                    contents = contents.filter { |content| content[title] < refValue }
                when ">"
                    contents = contents.filter { |content| content[title] > refValue }
                end
                contents.unshift(head)
            end
        else
            puts("There is no table called #{tableName}")
        end

        return contents
    end

    def orderBy(contents, order_by)
        if order_by != ""
            head = contents.first
            contents = contents.slice(1, contents.size-1)
            arr, n = [], head.index(order_by)
            contents.each do |content|
                inserted = false
                arr.each do |a|
                    if isNumeric(content[n], a[n])
                        arr.insert(arr.index(a), content)
                        inserted = true; break
                    end
                end
                arr.push(content) unless inserted
            end
            return arr.unshift(head)
        else
            return contents
        end
    end
end
