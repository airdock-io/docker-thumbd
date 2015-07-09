# Thumbd

Docker Image for [Thumbd](https://github.com/geronimo-iia/thumbd) based on airdock/node:10

Thumbd is an image thumbnailing server built on top of Node.js, SQS, S3, and ImageMagick.

Purpose of this image is:

- offer thumbd service ready to run with docker
- based on airdock/node:10 (debian)


> Name: airdock/thumbd

***Status***: develop

***Dependencies***: airdock/node:10

***Few links***:

- [Thumbd patched](https://github.com/geronimo-iia/thumbd)
- [Origin Thumbd Project](https://github.com/bcoe/thumbd)


# Usage

You should have already install [Docker](https://www.docker.com/).

Configure your .env file and execute:

		docker run -d --name thumbd --env-file=.env  airdock/thumbd

## Configuration

Thumbd requires the following environment variables to be set:

* **AWS_KEY** the key for your AWS account (the IAM user must have access to the appropriate SQS and S3 resources).
* **AWS_SECRET** the AWS secret key.
* **BUCKET** the bucket to download the original images from. The thumbnails will also be placed in this bucket.
* **AWS_REGION** the AWS Region of the bucket. Defaults to: `us-east-1`.
* **CONVERT_COMMAND** the ImageMagick convert command. Defaults to `convert`.
* **REQUEST_TIMEOUT** how long to wait in milliseconds before aborting a remote request. Defaults to `15000`.
* **S3_ACL** the acl to set on the uploaded images. Must be one of `private`, or `public-read`. Defaults to `private`.
* **S3_STORAGE_CLASS** the storage class for the uploaded images. Must be either `STANDARD` or `REDUCED_REDUNDANCY`. Defaults to `STANDARD`.
* **SQS_QUEUE** the queue name to listen for image thumbnailing.

When running locally, I set these environment variables in a .env file.

See file .end.default

## Server


The thumbd server:

* listens for thumbnailing jobs on the queue specified.
* downloads the original image from our thumbnailng S3 bucket, or from an HTTP(s) resource.
	* HTTP resources are prefixed with `http://` or `https://`.
	* S3 resources are a path to the image in the S3 bucket indicated by the `BUCKET` environment variable.
* Uses ImageMagick to perform a set of transformations on the image.
* uploads the thumbnails created back to S3, with the following naming convention: `[original filename excluding extension]_[thumbnail suffix].[thumbnail format]`

Assume that the following thumbnail job was received over SQS:

```json
{
	"original": "example.png",
	"descriptions": [
		{
			"suffix": "tiny",
			"width": 48,
			"height": 48
		},
		{
			"suffix": "small",
			"width": 100,
			"height": 100,
			"background": "red"
		},
		{
			"suffix": "medium",
			"width": 150,
			"height": 150,
			"strategy": "bounded"
		}
	]
}
```

Once thumbd processes the job, the files stored in S3 will look something like this:

* **/example.png**
* **/example\_tiny.jpg**
* **/example\_small.jpg**
* **/example\_medium.jpg**

## Thumbnail Descriptions


The descriptions received in the thumbnail job describe the way in which thumbnails should be generated.

_description_ accepts the following keys:

* **suffix:** a suffix describing the thumbnail.
* **width:** the width of the thumbnail.
* **height:** the height of the thumbnail.
* **background:** background color for matte.
* **format:** what should the output format of the image be, e.g., `jpg`, `gif`, defaults to `jpg`.
* **strategy:** indicate an approach for creating the thumbnail.
	* **bounded (default):** maintain aspect ratio, don't place image on matte.
	* **matted:** maintain aspect ratio, places image on _width x height_ matte.
	* **fill:** both resizes and zooms into an image, filling the specified dimensions.
	* **strict:** resizes the image, filling the specified dimensions changing the aspect ratio
	* **manual:** allows for a custom convert command to be passed in:
	  * `%(command)s -border 0 %(localPaths[0])s %(convertedPath)s`
* **quality:** the quality of the thumbnail, in percent. e.g. `90`.
* **autoOrient:** true/false, whether to automatically rotate the photo based on EXIF data (for correcting orientation on phone images, etc)

See [Readme of thumbd project](https://github.com/geronimo-iia/thumbd/blob/master/README.md) for more information.

# Change Log

## TODO

- change thumbd import when patch will be released

## Tag latest (current)

- add thumbd patched version
- use user node:node
- MIT license


# Build


- Install "make" utility, and execute: `make build`
- Or execute: 'docker build -t airdock/thumbd:latest --rm .'

See [Docker Project Tree](https://github.com/airdock-io/docker-base/wiki/Docker-Project-Tree) for more details.


# MIT License

```
The MIT License (MIT)

Copyright (c) 2015 Airdock.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
