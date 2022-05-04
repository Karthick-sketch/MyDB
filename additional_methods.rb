load "table.rb"

class AdditionalMethods
    def initialize(db)
        @database = db
    end

    def getDatabase()
        return @database
    end

    def getFileName(tableName)
        return "./databases/#{@database}/#{tableName}.csv"
    end

    def isNumeric(n1, n2)
        begin
            return Float(n1) < Float(n2)
        rescue
            return n1 < n2
        end
    end
end
