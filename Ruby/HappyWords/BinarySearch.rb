class BinarySearch
    # Requires that arr be sorted
    def self.Search(arr, searchItem, startIdx, endIdx)
        if startIdx > endIdx
            return -1
        end

        midIdx = ((endIdx-startIdx) / 2) + startIdx
        
        if arr[midIdx] < searchItem
            return Search arr, searchItem, midIdx+1, endIdx
        end

        if arr[midIdx] > searchItem
            return Search arr, searchItem, startIdx, midIdx-1
        end

        return midIdx
    end

    # Requires arr be sorted
    def self.InArray(arr, searchItem)
        if !arr
            return false
        end

        result = Search arr, searchItem, 0, arr.length-1

        return result >= 0
    end
    
    # Requires arr be sorted
    def self.CountOccurrences(arr, searchItem)
        if !arr
            return 0
        end
        
        idx = Search arr, searchItem, 0, arr.length-1

        # Not found, no ocurrences
        if idx < 0
            return 0
        end

        leftIdx = idx-1
        # Count elements left of the idx
        while leftIdx >= 0 && arr[leftIdx] == searchItem
            leftIdx -= 1
        end

        # Count elements right of the idx
        rightIdx = idx+1
        while arr[rightIdx] == searchItem
            rightIdx += 1
        end

        return rightIdx - leftIdx - 1
    end
end

