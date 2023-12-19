import { LightningElement } from 'lwc';
import readPuzzleInput from '@salesforce/apex/Advent.readPuzzleInput';

export default class AdventofCode_FileReader extends LightningElement {
    puzzleInput;
    puzzleInputFileName;
    puzzleAnswer;

    handlePuzzleInputChange(event) {
        this.puzzleInput = event.target.files[0];
        this.puzzleInputFileName = event.target.files[0].name;
    }

    get disabled() {
        return this.puzzleInput ? false : true; 
    }

    uploadPuzzleInput() {
        if (this.puzzleInput) {
            const reader = new FileReader();
            reader.onload = () => {
                const fileContent = reader.result;

                // process the puzzle input
                readPuzzleInput({ fileName: this.puzzleInput.name, fileContent })
                    .then(result => {
                        // Handle success
                        console.log('File uploaded successfully:', result);
                        this.puzzleAnswer = result;
                    })
                    .catch(error => {
                        // Handle error
                        console.error('Error uploading file:', error);
                    });
            };
            reader.readAsText(this.puzzleInput);
        }
    }
}