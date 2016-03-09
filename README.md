# howdo_bash
simple programming answers on your shell

howdo also caches each question-answer pair in your home folder, so you have answers you need often available offline.

# usage
```
$ howdo malloc vs calloc
```


```
$ howdo malloc vs calloc
https://duckduckgo.com/html/?q=malloc+vs+calloc+site:stackoverflow.com
=====================

    
calloc() zero-initializes the buffer, while malloc() leaves the memory u
ninitialized.

EDIT:

Zeroing out the memory may take a little time, so you probably want to use m
alloc() if that performance is an issue.  If initializing the memory is more imp
ortant, use calloc().  For example, calloc() might save you a call to 
memset().
    
    
see: [http://stackoverflow.com/questions/1538420/difference-between-malloc-a
nd-calloc]
=====================
```

Search is done via duckduckgo but you can change it to any search engine you want. 
