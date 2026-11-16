```
(git ls-files *.gd *.gdshader | xargs wc -l | grep -v "total" | sort -nr); (git ls-files *.gd *.gdshader | xargs wc -l | grep "total")
```