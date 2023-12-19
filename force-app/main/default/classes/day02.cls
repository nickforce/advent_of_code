public with sharing class day02 {

    public static Integer part2(List<String> puzzleInputLines) {
        Integer total = 0; 
        for(String line : puzzleInputLines) {
            Map<String, Integer> maxGameCubesByColor = new Map<String, Integer>();
            Integer gameNumber = Integer.valueOf(line.substring(line.indexOf(' ') + 1, line.indexOf(':')));
            String gameRounds = line.substring(line.indexOf(':') + 1, line.length());
            for(String round : gameRounds.split(';')) {
                for(String score : round.split(',')) {
                    String numberColor = score.trim();
                    Integer cubeNumber = Integer.valueOf(numberColor.substring(0,numberColor.indexOf(' ')));
                    String cubeColor = numberColor.substring(numberColor.indexOf(' ') + 1, numberColor.length());
                    
                    if(maxGameCubesByColor.get(cubeColor) == null) {
                        maxGameCubesByColor.put(cubeColor, cubeNumber);
                    }
                    // if new highest cube number, put in map
                    if(maxGameCubesByColor.get(cubeColor) < cubeNumber) {
                        maxGameCubesByColor.put(cubeColor, cubeNumber);
                    }
                }
            }
            total += powerOfMaxCubes(maxGameCubesByColor);
        }

        return total;
    }

    private static Integer powerOfMaxCubes(Map<String, Integer> maxGameCubesByColor) {
        System.debug(maxGameCubesByColor);
        Integer powerResult = maxGameCubesByColor.values()[0] * maxGameCubesByColor.values()[1] * maxGameCubesByColor.values()[2];
        System.debug(powerResult);
        return powerResult;
    }

    public static Map<String, Integer> maxTurnCubes = new Map<String, Integer>{
        'red' => 12,
        'green' => 13,
        'blue' => 14
    };
    
    public static Integer part1(List<String> puzzleInputLines) {
        Integer total = 0; 
        Set<Integer> validGameNumbers = new Set<Integer>();
        for(String line : puzzleInputLines) {
            Integer gameNumber = Integer.valueOf(line.substring(line.indexOf(' ') + 1, line.indexOf(':')));
            validGameNumbers.add(gameNumber);
            String gameRounds = line.substring(line.indexOf(':') + 1, line.length());
            for(String round : gameRounds.split(';')) {
                for(String score : round.split(',')) {
                    String numberColor = score.trim();
                    String cubeNumber = numberColor.substring(0,numberColor.indexOf(' '));
                    String cubeColor = numberColor.substring(numberColor.indexOf(' ') + 1, numberColor.length());

                    if(maxTurnCubes.get(cubeColor) < Integer.valueOf(cubeNumber)) {
                        validGameNumbers.remove(gameNumber);
                    }
                }
            }
        }

        return sumValidGameNumbers(validGameNumbers);
    }

    private static Integer sumValidGameNumbers(Set<Integer> validGameNumbers) {
        Integer sum = 0;
        for(Integer val : validGameNumbers) {
            sum += val;
        }
        return sum;
    }
}