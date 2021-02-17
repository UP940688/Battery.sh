Battery.sh
===
A small, quick bash script to present important battery information
to the user in a friendly way.

```bash
$ battery -r
Battery: 56%
Remaining Time: 3.57h
```

Arguments / Configuration
---

1\. Pass a custom directory to fetch battery information from.
```bash
-d=x / --directory=x
```


2\. Disable coloured output
```bash
--disable-pretty-print
```

3\. Display the current total capacity of the battery
```bash
-c / --capacity
```

4\. Display the estimated remaining time until battery dies
```bash
-r / --remaining
```
