load 'additional_methods.rb'

class DDL < AdditionalMethods
    def initialize(db)
        super(db)
    end

    def create(tableName, attributes)
        fileName = getFileName(tableName)
        unless (File.file?(fileName))
            file = File.new(fileName, "w")
            file.syswrite(encryption(attributes.join(",")+"\n"))
            file.close()
        else
            puts("#{tableName} table is already exists")
        end
    end
end
