public with sharing class Advent {
    @AuraEnabled
    public static Long readPuzzleInput(String fileName, String fileContent) {
        return read_lines(fileContent);
    }

    public static Long read_lines(String puzzleInput) {
        // Split by newline chars
        List<String> lines = puzzleInput.split('\n');
        // call puzzle solution
        return day07.part1(lines);
    }

}