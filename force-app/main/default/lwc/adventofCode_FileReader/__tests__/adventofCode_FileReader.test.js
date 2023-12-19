import { createElement } from 'lwc';
import AdventofCode_FileReader from 'c/adventofCode_FileReader';

describe('c-adventof-code-file-reader', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-adventof-code-file-reader', {
            is: AdventofCode_FileReader
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});