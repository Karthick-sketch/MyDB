module Table
    def Table.replaceString(arr, sym)
        return " " + (arr.map { |c| '-' * (c+2) }.join(sym))
    end

    def Table.maxCols(contents)
        cols = 0
        contents.each do |c|
            cols = c.size if c.size > cols
        end

        return cols
    end

    def Table.maxColContent(contents, cols)
        maxContent = []
        cols.times { maxContent << 0 }

        contents.each do |content|
            content.each_with_index do |c, i|
                maxContent[i] = c.size if maxContent[i] < c.size
            end
        end

        return maxContent
    end

    def Table.table(contents)
        cols = maxCols(contents)
        maxContent = maxColContent(contents, cols)
        cells = []; text = []

        layer = replaceString(maxContent, ' ')
        mid_layer = replaceString(maxContent, '+')

        contents.each do |content|
            content.each_with_index do |c, i|
                s = (maxContent[i] - c.size)
                spc = (s > 0 ? ' ' * (s/2) : '')
                text << ((s == 1 ? ' ' : ((s%2 == 1 ? ' ' : '') + spc)) + c + spc)
            end
            cells << "| #{text.join(' | ')} |\n"
            text.clear()
        end

        puts(layer, cells.join(mid_layer+"\n"), layer)
    end
end
