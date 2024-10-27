# A Docker image that runs multiple PHP versions

## Usage

### Docker host

Run a script with default PHP version.
```
docker run --rm -i attr/multi-php < script.php
```

Run a script with specific PHP version.
```
docker run --rm -i attr/multi-php php8.2 < script.php
# or
docker run --rm -i -v "$PWD":/var/www attr/multi-php php8.3 script.php
```
Run builtin web server with specific PHP version.
```
docker run --rm -i -v "$PWD":/var/www -p8080:8080 attr/multi-php php8.4 -S 0.0.0.0:8080
```

### Inside container

Set default PHP version.
```
update-alternatives --set php /usr/bin/php8.3
```

Set default PHP version (interactive mode).
```
update-alternatives --config php
```
