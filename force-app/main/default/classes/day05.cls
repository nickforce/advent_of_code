public with sharing class day05 {
    public static Integer part1(List<String> puzzleInputLines, String fullInput) {
        String seedRow = puzzleInputLines.remove(0);
        String[] seedValues = seedRow.split(': ')[1].split(' ');
        
        List<Seed> seeds = new List<Seed>();
        for(Integer i = 0; i < seedValues.size(); i += 2) {
            seeds.add(new Seed(Double.valueOf(seedValues[i]), Double.valueOf(seedValues[i + 1])));
        }

        List<String> contentRows = fullInput.split('\n\n');
        contentRows.remove(0);

        List<Map<String, Object>> parsed = new List<Map<String, Object>>();

        for(String content : contentRows) {
            Map<String, Object> parsedMap = parseMap(content);
            parsed.add(parsedMap);
        }
        System.debug(parsed);
        for(Map<String, Object> p : parsed) {
            List<Range> mapList = (List<Range>)p.get('map');
            p.put('map', createNegativeRanges(mapList));
        }

        Map<String, Object> parsedMap = new Map<String, Object>();

        for(Object x : parsed) {
            Map<String, Object> parsedObject = (Map<String, Object>)x;
            String key = (String)parsedObject.get('from');
            parsedMap.put(key, parsedObject);
        }
        System.debug(parsedMap);

        Double lowest = 99999999999999.0; // Use a large number to represent positive infinity

        for(Seed seed : seeds) {
            System.debug('start ' + seed);
            Double remaining = seed.length;
            Double start = seed.start;
            
            while(remaining > 0) {
                List<Double> walkResult = walk(start, remaining, 'seed', parsedMap);
                Double startLocation = walkResult[0];
                Double consumed = walkResult[1];
        
                remaining -= consumed;
                start += consumed;
        
                if(consumed > 1) {
                    System.debug('consumed ' + consumed);
                }
        
                if(startLocation < lowest) {
                    lowest = startLocation;
                }
            }
        
            System.debug('finished ' + seed);
        }

        System.debug(lowest);

        return 0;
    }

    public static Double highestValuePossible = 0;

    private static List<Range> createRange(List<String> rangeStrings) {
        List<Range> rangeList = new List<Range>();

        for (String rangeString : rangeStrings) {
            Range range = createRange(rangeString);
            rangeList.add(range);
        }

        return rangeList;
    }

    public static Range createRange(String line) {
        String[] items = line.split(' ');
        Range range = new Range(
            Integer.valueOf(items[0]), // dest  
            Integer.valueOf(items[1]), // varSrc
            Integer.valueOf(items[2]) // varRange
        );

        highestValuePossible = Math.max(highestValuePossible,
            Math.max(
                range.src + range.range,
                range.dest + range.range
            )
        );

        return range;
    }

    public static List<Range> createNegativeRanges(List<Range> ranges) {
        ranges.sort();

        Integer start = 0;
        for(Integer i = 0; i < ranges.size(); i++) {
            Range range = ranges[i];
            if(range.src > start) {
                ranges.add(i, new Range(
                    start, 
                    start, 
                    range.src - start
                ));
                i++;
            }
            start = range.src + range.range;
        }
        return ranges;
    }

    public static Map<String, Object> parseMap(String data) {
        List<String> contents = data.split('\n');
        for (Integer i = contents.size() - 1; i >= 0; i--) {
            if (contents[i].trim() == '') {
                contents.remove(i);
            }
        }

        List<String> rangeData = contents.remove(0).split(' ')[0].split('-');
        String fromVal = rangeData[0];
        String to = rangeData[2];

        Map<String, Object> result = new Map<String, Object>{
            'from' => fromVal,
            'to' => to,
            'map' => createRange(contents)
        };

        return result;
    }

    public static List<Double> walk(Double value, Double range, String name, Map<String, Object> objMap) {
        if (!objMap.containsKey(name)) {
            return new List<Double>{value, range};
        }
    
        Map<String, Object> item = (Map<String, Object>)objMap.get(name);
        List<Range> rangeList = (List<Range>)item.get('map');
    
        for(Range rangeItem : rangeList) {
            if (rangeItem.src <= value && value < rangeItem.src + rangeItem.range) {
                Double diff = value - rangeItem.src;
                Double newValue = rangeItem.dest + diff;
                return walk(newValue, Math.min(range, rangeItem.range - diff), (String)item.get('to'), objMap);
            }
        }
    
        return walk(value, 1, (String)item.get('to'), objMap);
    }

    public class Range implements Comparable {
        public Integer dest {get;set;}
        public Integer src {get;set;}
        public Integer range {get;set;}
        public Range(Integer varDest, Integer varSrc, Integer varRange) {
            dest = varDest;
            src = varSrc;
            range = varRange;
        }

        public Integer compareTo(Object obj) {
            Range otherRange = (Range)obj;
            return (Integer)this.src - (Integer)otherRange.src;
        }
    }

    public class Seed {
        public Double start {get;set;}
        public Double length {get;set;}
        public Seed(Double varStart, Double varLength) {
            start = varStart;
            length = varLength;
        }
    }
}



/* example input

seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4

*/