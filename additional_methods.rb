load "table.rb"

class AdditionalMethods
    def initialize(db)
        @database = db
    end

    def getDatabase()
        return @database
    end

    def getFileName(tableName)
        return "./databases/#{@database}/#{tableName}.mydb"
    end

    def isNumeric(n1, n2)
        begin
            return Float(n1) < Float(n2)
        rescue
            return n1 < n2
        end
    end

    def encryption(text)
        st = ""
        text.split("").each do |ch|
            var = ch.ord
            if var == 32
                var = 126
            elsif var > 32 and var < 127
                var -= 1
            end
            st += var.chr
        end

        return st
    end

    def decryption(text)
        st = ""
        text.split("").each do |ch|
            var = ch.ord
            if var == 126
                var = 32
            elsif var > 31 and var < 126
                var += 1
            end
            st += var.chr
        end

        return st
    end
end
