Battery.sh
===
A small, quick bash script to present important battery information
to the user in a friendly way.

```bash
$ battery -r
Battery: 56%
Remaining Time: 3.57h
```

Arguments
---
The script supports only four arguments:

```bash
-d=x / --directory=x
```

Pass a custom directory to fetch battery information from.

```bash
--disable-pretty-print
```

Disable coloured output

```bash
-c / --capacity
```

Display the current total capacity of the battery

```bash
-r / --remaining
```

Display the estimated remaining time until battery dies
