Package talk at Toronto Data Workshop (Kuriwaki, Feb 2021)
=======================

<https://www.youtube.com/watch?v=-J-eiPnmoNE&t=1s>



Notes for Datafest 2021 Workshop (Beasley, Jan 2021)
=======================

https://projects.iq.harvard.edu/datafest2021

If you are downloading a single data file once, it may make sense to ignore APIs.  Instead just manually download the file and manually move it to the appropriate directory.  --But it's rarely one-and-done in our world.

It's rarely one-and-done for many reasons, such as:

* the larger dataset contains dozens of files, or
* the covid dataset is updated with relevant & fresh information daily, or
* you run it on a different computer a few months later, or *and this is the heart of reproducibility*
* you want someone else to be able to unambiguously & effortlessly produce the same analysis using the same dataset.

Instead of telling your students or colleagues "first go to this site, then download these files, then move the files to this these subdirectories, and finally convert them to this format before you run these models" ...say it with ten lines of code.

The Dataverse clients for R and Python allow you to do just that.  You use simple code to replace tedious & error-prone manual steps to facilitate reproducibility of analyses.  The R & Python packages have the narrow goal of interacting with the server to acquire (and possibly transform) datasets, but then get out of the way so the data can be piped into the many analytical packages offered in both languages.


Remember that a dataverse data*set* may contain multiple files.  `get_dataset` retrieved and inspected the contents. Then you can use `get_file` to retrieve the contents of each file. The content is in a binary form, unusable in R. You can write it as a binary file with the base R `writeBin`, and then re-read it with an appropriate R function.

If you're a Dataverse beginner, consider if you want to use the web browser --instead of R-- to explore the dataset and identify the specific datafile you want.  The `get_dataframe_by_name` code is one line combines two steps: (1) retrieving content from the Dataverse server and then (2) calls a function to transforms the content into an R dataframe, regardless if it's originally a csv, rds, Stata file, etc. 

For people copying & pasting your code into their machines ...the API is so integrated and responsive that they may not even realize their computer is connecting to the outside world.  If they're not looking closely, they may think it's data that included locally in a package they've already installed.
