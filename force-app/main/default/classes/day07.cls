public with sharing class day07 {
    
    public static Integer part1(List<String> puzzleInputLines) {
        List<GameObject> games = parseGames(puzzleInputLines);
        games.sort();
        return getMultipliedBetSum(games);
    }

    // public static Integer part2(String input) {
    //     List<GameObject> games = parseInput(input);
    //     List<GameObject> sortedGames = sortGamesJokerRule(games);
    //     return getMultipliedBetSum(sortedGames);
    // }

    public static Integer getMultipliedBetSum(List<GameObject> sortedGames) {
        Integer rank = 1;
        Integer res = 0;

        for (GameObject game : sortedGames) {
            res += game.bet * rank;
            rank++;
        }

        return res;
    }

    public static Boolean hand1IsWinner(String hand1, String hand2) {
        Integer hand1Weight = getHandWeight(hand1);
        Integer hand2Weight = getHandWeight(hand2);

        if (hand1Weight == hand2Weight) {
            return handleSameType(hand1, hand2, false);
        } else {
            return hand1Weight > hand2Weight;
        }
    }

    public static Map<String, Integer> getCardWeights(Boolean joker) {
        Map<String, Integer> cardWeights = new Map<String, Integer>();

        if (!joker) {
            cardWeights = new Map<String, Integer>{
                '2' => 1,
                '3' => 2,
                '4' => 3,
                '5' => 4,
                '6' => 5,
                '7' => 6,
                '8' => 7,
                '9' => 8,
                'T' => 9,
                'J' => 10,
                'Q' => 11,
                'K' => 12,
                'A' => 13
            };
        } else {
            cardWeights = new Map<String, Integer>{
                '2' => 1,
                '3' => 2,
                '4' => 3,
                '5' => 4,
                '6' => 5,
                '7' => 6,
                '8' => 7,
                '9' => 8,
                'T' => 9,
                'J' => 0,
                'Q' => 11,
                'K' => 12,
                'A' => 13
            };
        }

        return cardWeights;
    }

    public static Boolean handleSameType(String hand1, String hand2, Boolean joker) {
        Map<String, Integer> cardWeights = getCardWeights(joker);

        for (Integer i = 0; i < hand1.length(); i++) {
            String check1 = hand1.substring(i, i + 1);
            String check2 = hand2.substring(i, i + 1);
            Boolean hand1Wins = cardWeights.get(check1) > cardWeights.get(check2);
            Boolean hand2Wins = cardWeights.get(check1) < cardWeights.get(check2);

            if (hand1Wins) {
                return true;
            } else if (hand2Wins) {
                return false;
            }
        }
        return true;
    }

    public static Integer getHandWeight(String hand) {
        Map<String, Integer> counts = getCardCounts(hand);
    
        if (isFiveOfAKind(counts)) {
            return 7;
        } else if (isFourOfAKind(counts)) {
            return 6;
        } else if (isFullHouse(counts)) {
            return 5;
        } else if (isThreeOfAkind(counts)) {
            return 4;
        } else if (isTwoPair(counts)) {
            return 3;
        } else if (isOnePair(counts)) {
            return 2;
        } else if (isHighCard(counts)) {
            return 1;
        } else {
            return 0;
        }
    }

    public static Boolean isHighCard(Map<String, Integer> counts) {
        for (String key : counts.keySet()) {
            if (counts.get(key) > 1) {
                return false;
            }
        }
        return true;
    }

    public static Boolean isOnePair(Map<String, Integer> counts) {
        Integer pairsCount = 0;

        for (String key : counts.keySet()) {
            if (counts.get(key) == 2) {
                pairsCount++;
            }
        }

        return pairsCount == 1;
    }

    public static Boolean isTwoPair(Map<String, Integer> counts) {
        Integer pairsCount = 0;

        for (String key : counts.keySet()) {
            if (counts.get(key) == 2) {
                pairsCount++;
            }
        }

        return pairsCount == 2;
    }

    public static Boolean isFullHouse(Map<String, Integer> counts) {
        Boolean roof = false;
        Boolean base = false;

        for (String key : counts.keySet()) {
            if (counts.get(key) == 2) {
                roof = true;
            }
            if (counts.get(key) == 3) {
                base = true;
            }
        }

        return roof && base;
    }

    public static Boolean isThreeOfAkind(Map<String, Integer> counts) {
        if (isFullHouse(counts)) {
            return false;
        }

        for (String key : counts.keySet()) {
            if (counts.get(key) == 3) {
                return true;
            }
        }

        return false;
    }

    public static Boolean isFourOfAKind(Map<String, Integer> counts) {
        for (String key : counts.keySet()) {
            if (counts.get(key) == 4) {
                return true;
            }
        }

        return false;
    }

    public static Boolean isFiveOfAKind(Map<String, Integer> counts) {
        for (String key : counts.keySet()) {
            if (counts.get(key) == 5) {
                return true;
            }
        }

        return false;
    }

    public static Map<String, Integer> getCardCounts(String hand) {
        Map<String, Integer> counts = new Map<String, Integer>();

        for (Integer i = 0; i < hand.length(); i++) {
            String card = hand.substring(i, i + 1);

            if (!counts.containsKey(card)) {
                counts.put(card, 1);
            } else {
                counts.put(card, counts.get(card) + 1);
            }
        }

        return counts;
    }

    public static List<GameObject> parseGames(List<String> input) {
        List<GameObject> games = new List<GameObject>();

        for(Integer i = 0; i < input.size(); i++) {
            String hand = input[i].split(' ')[0];
            String bet = input[i].split(' ')[1];
            games.add(new GameObject(hand, Integer.valueOf(bet)));
        }

        return games;
    }
    
    public class GameObject implements Comparable {
        public String hand;
        public Integer bet;

        public GameObject(String hand, Integer bet) {
            this.hand = hand;
            this.bet = bet;
        }

        // Implementing the compareTo method from the Comparable interface
        public Integer compareTo(Object compareTo) {
            GameObject compareToGame = (GameObject)compareTo;

            if (hand1IsWinner(this.hand, compareToGame.hand)) {
                return 1;
            } else if (hand1IsWinner(compareToGame.hand, this.hand)) {
                return -1;
            } else {
                return 0;
            }
        }
    }
}

/* example input

32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483

*/

