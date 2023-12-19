public with sharing class day04 {
    
    public static Integer part2(List<String> puzzleInputLines) {
        Map<Integer,Integer> cardNumberToCopies = new Map<Integer,Integer>();
        Map<Integer,Integer> cardNumberToWinners = new Map<Integer,Integer>();
        // iterate each card
        for(Integer i = 0; i < puzzleInputLines.size(); i++) {
            String card = puzzleInputLines[i];
            Integer cardNumber = Integer.valueOf(card.substring(card.indexOf(' ') + 1, card.indexOf(':')).trim());
            Integer totalCardWinners = processTotalCardWinners(puzzleInputLines[i]);
            cardNumberToCopies.put(cardNumber, 1);
            cardNumberToWinners.put(cardNumber, totalCardWinners);
        }

        for(Integer i = 0; i < puzzleInputLines.size(); i++) {
            String card = puzzleInputLines[i];
            Integer cardNumber = Integer.valueOf(card.substring(card.indexOf(' ') + 1, card.indexOf(':')).trim());
        
            for(Integer y = 1; y <= cardNumberToWinners.get(cardNumber); y++) {
                Integer nextCardNumber = cardNumber + y;
                // Your copy of card 2 also wins one copy each of cards 3 and 4.
                Integer currentCopies = cardNumberToCopies.get(nextCardNumber) + 1;
                cardNumberToCopies.put(nextCardNumber, currentCopies);

            }
        }

        Integer totalCards = 0;
        for(Integer copy : cardNumberToCopies.values()) {
            totalCards += copy;
        }
        return totalCards;
    }

    public static Integer part1(List<String> puzzleInputLines) {
        Integer cardPoints = 0;
        // iterate each card
        for(Integer i = 0; i < puzzleInputLines.size(); i++) {
            Integer totalCardWinners = processTotalCardWinners(puzzleInputLines[i]);
            cardPoints += calculatePoints(totalCardWinners);
        }
        return cardPoints;
    }

    public static Integer processTotalCardWinners(String card) {
        String winningNumbers = card.substring(card.indexOf(':') + 1, card.indexOf('|'));
        String myNumbers = card.substring(card.indexOf('|') + 1, card.length());
        List<Integer> resultWinning = new List<Integer>(convertToListOfIntegers(winningNumbers));
        List<Integer> resultMyNumbers = convertToListOfIntegers(myNumbers);
        // card map
        Map<Set<Integer>,List<Integer>> cardMap = new Map<Set<Integer>,List<Integer>>();
        cardMap.put(
            new Set<Integer>(convertToListOfIntegers(winningNumbers)), 
            convertToListOfIntegers(myNumbers)
        );
        return calculateCardWinners(cardMap);
    }

    public static Integer calculateCardWinners(Map<Set<Integer>,List<Integer>> cardMap) {
        Integer cardTotalWinners = 0;
        for(Set<Integer> winners : cardMap.keySet()) {
            for(Integer myNumber : cardMap.get(winners)) {
                if(winners.contains(myNumber)) {
                    cardTotalWinners++;
                }
            }
        }
        return cardTotalWinners;
    }

    public static Integer calculatePoints(Integer cardTotalWinners) {
        if(cardTotalWinners < 1) {
            return 0;
        }
        // first winner is 1 point
        Integer points = 1;
        // double the score for each point after 1
        for(Integer i = 2; i <= cardTotalWinners; i++) {
            points *= 2;
        }
        return points;
    }

    public static List<Integer> convertToListOfIntegers(String inputString) {
        List<Integer> integerList = new List<Integer>();

        // Split the string into an array of substrings
        List<String> stringArray = inputString.trim().split(' ');
        // Convert each substring to an integer and add to the list
        for(String str : stringArray) {
            if(String.isNotBlank(str)) {
                integerList.add(Integer.valueOf(str.trim()));
            }
        }

        return integerList;
    }
}