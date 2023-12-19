public with sharing class day01 {
    public static Map<String,String> numberMap = new Map<String,String>{
        'one' => '1',
        'two' => '2',
        'three' => '3',
        'four' => '4',
        'five' => '5',
        'six' => '6',
        'seven' => '7',
        'eight' => '8',
        'nine' => '9',
        '1' => '1',
        '2' => '2',
        '3' => '3',
        '4' => '4',
        '5' => '5',
        '6' => '6',
        '7' => '7',
        '8' => '8',
        '9' => '9'
    };

    public static Integer part2(List<String> puzzleInputLines) {
        System.debug(puzzleInputLines);
        Integer total = 0;
        for(String line : puzzleInputLines) {
            System.debug(line);
            String fullMatch = matchIncludingSpelledOutNumbers(line);
            total += Integer.valueOf(fullMatch);
        }

        return total;
    }
    
    public static String matchIncludingSpelledOutNumbers(String line) {
        List<String> returnVal = new List<String>();
        // Iterate through each character in the line (first match)
        for (Integer i = 0; i < line.length(); i++) {
            // Get the character string at the current index to the end
            String currentChars = line.substring(i, line.length());
            for(String numKey : numberMap.keySet()) {
                // check if starts with matches a key in the spelled out number map
                if(currentChars.startsWith(numKey)) {
                    returnVal.add(numberMap.get(numKey));
                }
            }
        }
        return returnVal[0] + returnVal[returnVal.size() - 1];
    }
    
    public static Integer part1(List<String> puzzleInputLines) {
        System.debug(puzzleInputLines);
        Integer total = 0;
        for(String line : puzzleInputLines) {
            System.debug(line);
            String first = firstMatch(line);
            String last = lastMatch(line);
            String fullMatch = first + last;
            total += Integer.valueOf(fullMatch);
        }

        return total;
    }

    public static String firstMatch(String line) {
        String returnVal;
        // Iterate through each character in the line (first match)
        for (Integer i = 0; i < line.length(); i++) {
            // Get the character at the current index
            String currentChar = line.substring(i, i + 1);
            if(numberMap.get(currentChar) != null) {
                returnVal = numberMap.get(currentChar);
                break;
            }
        }
        return returnVal;
    }

    public static String lastMatch(String line) {
        String returnVal;
        // Iterate through each character in the line in reverse order (last match)
        for (Integer i = line.length() - 1; i >= 0; i--) {
            // Get the character at the current index
            String currentChar = line.substring(i, i + 1);
            if(numberMap.get(currentChar) != null) {
                returnVal = numberMap.get(currentChar);
                break;
            }
        }
        return returnVal;
    }
}