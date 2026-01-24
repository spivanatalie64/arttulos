# Usage Examples: PacNixum

## Basic Usage
```
./cli.scrapec install nano
./cli.scrapec remove nano
./cli.scrapec search nano
```

## Advanced Menu
```
./cli.scrapec --advanced
```

# Usage Examples: AI Assistant

## Querying
```
./main.scrapec query "What is PacNixum?"
```

## Listing Plugins
```
./main.scrapec plugins list
```

# Usage Examples: ScrapeC

## FFI Example
```
let result = scrapec::ffi::call_c("puts", ["Hello"]);
```

## Async Example
```
let result = scrapec::async::run(async { 42 });
```
