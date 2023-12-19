public with sharing class day03 {

    public static Integer part2(List<String> puzzleInputLines) {
        List<Integer> validGearRatios = new List<Integer>();
        // engine part row
        for(Integer i = 0; i < puzzleInputLines.size(); i++) {
            // engine part columns
            for(Integer col = 0; col < puzzleInputLines[i].length(); col++) {
                String[] columnChars = puzzleInputLines[i].split('');
                // Check if the character is * a gear
                if(isGear(columnChars[col])) {
                    Set<Integer> validIndexes = new Set<Integer>();
                    // left adjacent start index
                    Integer leftAdjacentStartIndex = col - 1;
                    // right adjacent end index
                    Integer rightAdjacentEndIndex = col + 1;
                    // increment to end of current partnumber
                    col += 1;
                    // get previous row
                    String prevRow = i-1 == -1 ? null : puzzleInputLines[i-1];
                    // get next row
                    String nextRow = i+1 == puzzleInputLines.size() ? null : puzzleInputLines[i+1];

                    // find valid indexes
                    validIndexes = getIntegerRange(leftAdjacentStartIndex, rightAdjacentEndIndex, puzzleInputLines[i].length());

                    // current row, prev row, next row
                    Set<Integer> gearRatios = getAdjacentGearRatios(validIndexes, puzzleInputLines[i], prevRow, nextRow);

                    if(gearRatios.size() == 2) {
                        List<Integer> gearRatiosList = new List<Integer>(gearRatios);
                        validGearRatios.add(gearRatiosList[0] * gearRatiosList[1]);
                        continue;
                    }
                }
            }
        }
        return sumListIntegers(validGearRatios);
    }

    public static Set<Integer> getAdjacentGearRatios(Set<Integer> indexes, String row, String prevRow, String nextRow) {
        Set<Integer> gearRatios = new Set<Integer>();
        for(Integer index : indexes) {
            // current row
            String currentIndexChar = row.split('')[index];
            if(isDigit(currentIndexChar)) {
                gearRatios.add(getFullNumber(index, row));
            }
            if(prevRow != null) {
                // prev row
                String prevIndexChar = prevRow.split('')[index];
                if(isDigit(prevIndexChar)) {
                    gearRatios.add(getFullNumber(index, prevRow));
                }
            }
            if(nextRow != null) {
                // next row
                String nextIndexChar = nextRow.split('')[index];
                if(isDigit(nextIndexChar)) {
                    gearRatios.add(getFullNumber(index, nextRow));
                }
            }
        }
        return gearRatios;
    }

    public static Integer getFullNumber(Integer foundIndex, String row) {
        // Traverse backward
        String backwardResult = extractDigitsFromString(row, foundIndex, -1);
        // Traverse forward
        String forwardResult = extractDigitsFromString(row, foundIndex + 1, 1);

        return Integer.valueOf(backwardResult + forwardResult);
    }

    private static String extractDigitsFromString(String inputString, Integer startIndex, Integer step) {
        String result = '';

        for(Integer i = startIndex; i >= 0 && i < inputString.length(); i += step) {
            String[] columnChars = inputString.split('');
            // Check if the character is a digit
            if (isDigit(columnChars[i])) {
                // Append the digit to the result
                // backwards
                if(step == -1) {
                    result = columnChars[i] + result;
                } else if (step == 1) { // forwards
                    result = result + columnChars[i];
                }
                
            } else {
                // Break the loop if a non-digit character is encountered
                break;
            }
        }

        return result;
    }

    public static Boolean isGear(String ch) {
        return (ch == '*');
    }
    
    public static Integer part1(List<String> puzzleInputLines) {
        List<Integer> validPartNumbers = new List<Integer>();
        // engine part row
        for(Integer i = 0; i < puzzleInputLines.size(); i++) {
            // engine part columns
            for(Integer col = 0; col < puzzleInputLines[i].length(); col++) {
                String[] columnChars = puzzleInputLines[i].split('');
                // Check if the character is not a letter or a digit
                if(isDigit(columnChars[col])) {
                    Set<Integer> validIndexes = new Set<Integer>();
                    // left adjacent start index
                    Integer leftAdjacentStartIndex = col - 1;
                    // parse out the part number
                    String partNumber = parsePartNumber(puzzleInputLines[i].substring(col, puzzleInputLines[i].length()));
                    // increment to end of current partnumber
                    col += partNumber.length()-1;
                    Integer rightAdjacentEndIndex = col + 1;
                    // find valid indexes
                    validIndexes = getIntegerRange(leftAdjacentStartIndex, rightAdjacentEndIndex, puzzleInputLines[i].length());
                    
                    // get previous row
                    String prevRow = i-1 == -1 ? null : puzzleInputLines[i-1];
                    // get next row
                    String nextRow = i+1 == puzzleInputLines.size() ? null : puzzleInputLines[i+1];

                    Integer valPartNumber = Integer.valueOf(partNumber);
                    
                    // current row, prev row, next row
                    if(hasAdjacentSymbol(puzzleInputLines[i], validIndexes) ||
                        (prevRow != null && hasAdjacentSymbol(prevRow, validIndexes)) ||
                        (nextRow != null && hasAdjacentSymbol(nextRow, validIndexes))) {
                        
                        validPartNumbers.add(valPartNumber);
                        continue;
                    }
                }
            }
        }
        return sumListIntegers(validPartNumbers);
    }

    public static Integer sumListIntegers(List<Integer> partNumbers) {
        Integer sum = 0;
        for(Integer value : partNumbers) {
            sum += value;
        }
        return sum;
    }

    public static Boolean hasAdjacentSymbol(String row, Set<Integer> indexes) {
        Boolean isValid = false;
        for(Integer index : indexes) {
            String currentIndexChar = row.split('')[index];
            if(isSymbol(currentIndexChar)) {
                isValid = true;
                break;
            }
        }
        return isValid;
    }

    public static Set<Integer> getIntegerRange(Integer startNumber, Integer endNumber, Integer rowLength) {
        Set<Integer> result = new Set<Integer>();
        for(Integer i = startNumber; i <= endNumber; i++) {
            // check if out of range indexes before adding
            if(i != -1 && i < rowLength) {
                result.add(i);
            }
        }
        return result;
    }

    public static String parsePartNumber(String beginningPartNumber) {
        String partNumber = '';
        for(Integer i = 0; i < beginningPartNumber.length(); i++) {
            if(isDigit(beginningPartNumber.substring(i, i + 1))) {
                partNumber += beginningPartNumber.substring(i, i + 1);
            } else { // end of part number
                break;
            }
        }
        return partNumber;
    }

    public static Boolean isSymbol(String ch) {
        return !isDigit(ch) && ch != '.';
    }

    public static Boolean isDigit(String ch) {
        return (ch >= '0' && ch <= '9');
    }
}