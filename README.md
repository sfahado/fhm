# Project Title

Sample project for full health medicine.

## Description

More description is found here.
https://gist.github.com/rodrigofhm/d7b8c38ef966250160ed71ce59a7822c

## Getting Started

### Dependencies

* Rspec
* ruby

### Installing
* ruby 2.7.5p203

### Executing program

* `ruby parser.rb` to run the main scraper script.
* `rspec spec/*` to execute the test cases.


## Assumptions

```
1. There must always some sequence with the test data, OBX row comes first and NTE later.
2. RESULT_CODE and LABORATORY_RESULT_FORMAT, used in LaboratoryTestResult are constants and can be dynamic based on future requirments.
3. `mapped_results` used in the Parser class return array of objects, I used that in Rspec testing.
```

## Authors

Contributors names and contact info

ex. Fahid Idrees
ex. [@sfahado](https://github.com/sfahado)

## Version History

* 0.1
    * Initial Release and project
* 0.2
  * Added the rspec coverage.
  * Module that contains util functions.
  * Some code optimizations and refactoring

## License

This project is the private property of full health medicine and cannot use for any commercial purposes. 

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
