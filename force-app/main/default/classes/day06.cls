public with sharing class day06 {
    public static Long part2(List<String> puzzleInputLines) {
        Long winningAttempts = 0;
        Map<Long,Long> timeToDistance = parseSingleRace(puzzleInputLines);
        for(Long varTime : timeToDistance.keySet()) {
            // winningAttempts += getWaysToWinQuadratic(varTime, timeToDistance.get(varTime));
            
            Long max = binarySearchHi(varTime, timeToDistance.get(varTime));
            Long min = binarySearchLo(varTime, timeToDistance.get(varTime));
            winningAttempts = (max - min) * -1;
        }

        return winningAttempts;
    }

    // refactored quadratic equation 
    public static Long getWaysToWinQuadratic(Long varTime, Long distance) {
        // Quadratic formula
        Double a = -1.0;
        Double b = (Double)varTime;
        Double c = -1.0 * (Double)distance;

        Double discriminant = Math.pow(b, 2) - 4 * a * c;

        if (discriminant < 0) {
            // No real roots, return 0
            return 0;
        }

        Long xMin = (Long)Math.floor((-b + Math.sqrt(discriminant)) / (2 * a)) + 1;
        Long xMax = (Long)Math.ceil((-b - Math.sqrt(discriminant)) / (2 * a)) - 1;
        System.debug(xMin);
        System.debug(xMax);
        return xMax - xMin + 1;
    }

    // highest
    public static Long binarySearchHi(Long varTime, Long varDistance) {
        Long totalCount = 0;

        Long left = 0;
        Long right = varTime;

        while (left <= right) {
            Long mid = left + (right - left) / 2;

            if (mid * (varTime - mid) > varDistance) {
                // If the condition is met, update totalCount and move to the left subsequence
                totalCount = mid.intValue();
                right = mid - 1;
            } else {
                // Move to the right subsequence
                left = mid + 1;
            }
        }

        return totalCount;
    }


    // lowest
    public static Long binarySearchLo(Long varTime, Long varDistance) {
        Long totalCount = 0;

        Long left = 0;
        Long right = varTime;

        while (left <= right) {
            Long mid = left + (right - left) / 2;

            if (mid * (varTime - mid) > varDistance) {
                // Increment count and move to the left subsequence
                totalCount += (right - mid + 1);
                right = mid - 1;
            } else {
                // Move to the right subsequence
                left = mid + 1;
            }
        }

        return totalCount;
    }
    

    public static Integer part1(List<String> puzzleInputLines) {
        Map<Integer,Integer> timeToDistance = parseTimeToDistanceMap(puzzleInputLines);
        System.debug(timeToDistance);
        Integer winningAttemptsMultipled = 1;
        for(Integer varTime : timeToDistance.keySet()) {
            winningAttemptsMultipled *= calculateWinningScenarios(varTime, timeToDistance.get(varTime));
        }
        return winningAttemptsMultipled;
    }

    public static Integer calculateWinningScenarios(Integer varTime, Integer distance) {
        Integer winningAttempts = 0;
        
        for(Integer i = 1; i < varTime; i++) {
            if((i * (varTime - i)) > distance) {
                winningAttempts++;
            }
        }

        return winningAttempts;
    }

    public static Long calculateWinningScenarios(Long varTime, Long distance) {
        Long winningAttempts = 0;
        
        for(Integer i = 1; i < varTime; i++) {
            if((i * (varTime - i)) > distance) {
                winningAttempts++;
            }
        }

        return winningAttempts;
    }

    public static Map<Long,Long> parseSingleRace(List<String> puzzleInputLines) {
        Map<Long,Long> timeToDistance = new Map<Long,Long>();
        for(Integer i = 0; i < puzzleInputLines.size(); i += 2) {
            List<String> timeRow = puzzleInputLines[i].split(' ');
            timeRow.remove(0);
            String timeParsed = '';
            for(Integer j = 0; j < timeRow.size(); j++) {
                if(timeRow[j].trim().isNumeric()) {
                    timeParsed += timeRow[j].trim();
                }
            }
            

            List<String> distanceRow = puzzleInputLines[i+1].split(' '); 
            distanceRow.remove(0);
            String distanceParsed = '';
            
            for(Integer j = 0; j < distanceRow.size(); j++) {
                if(distanceRow[j].trim().isNumeric()) {
                    distanceParsed += distanceRow[j].trim();
                }
            }
            timeToDistance.put(Long.valueOf(timeParsed), Long.valueOf(distanceParsed));
        }
        return timeToDistance;
    }

    public static Map<Integer,Integer> parseTimeToDistanceMap(List<String> puzzleInputLines) {
        Map<Integer,Integer> timeToDistance = new Map<Integer,Integer>();
        for(Integer i = 0; i < puzzleInputLines.size(); i += 2) {
            List<String> timeRow = puzzleInputLines[i].split(' ');
            timeRow.remove(0);
            List<Integer> timeParsed = new List<Integer>();
            for(Integer j = 0; j < timeRow.size(); j++) {
                if(timeRow[j].trim().isNumeric()) {
                    timeParsed.add(Integer.valueOf(timeRow[j].trim()));
                }
            }
            List<Integer> distanceParsed = new List<Integer>();
            List<String> distanceRow = puzzleInputLines[i+1].split(' '); 
            distanceRow.remove(0);
            for(Integer j = 0; j < distanceRow.size(); j++) {
                if(distanceRow[j].trim().isNumeric()) {
                    distanceParsed.add(Integer.valueOf(distanceRow[j].trim()));
                }
            }
            for(Integer j = 0; j < timeParsed.size(); j++) {
                timeToDistance.put(timeParsed[j], distanceParsed[j]);
            }
        }
        return timeToDistance;
    }
}

/* example input

Time:      7  15   30
Distance:  9  40  200

*/