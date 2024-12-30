# JSON Mapper

## Setup

### 1. Clone or download this repository.

Clone the repository

```bash
git clone git@github.com:MartinM1312/json-mapper.git

cd json_mapper
```

### 2. Install gems

Run the following command

```bash
bundle install
```

### 3. Start the rails server

run

```bash
rails s
```

## Using the app

### 1. Endpoints

#### POST /ses_events/transform

This is the enpoint that receives JSON data and returns a
new JSON with specific info.

### 2. Making a POST Request

First make sure your Rails app is running locally on, for
example, http://localhost:3000

[this](app/assets/json_file/example_json.json) is the file
that contains the JSON you should use to make the post
request.

### Using postman

#### Create a New Postman Request

1. Open Postman and click + to create a new request tab.
2. Set the Method to POST.
3. Enter the URL:

```bash
http://localhost:3000/ses_events/transform
```

#### Configure the Body

1. Click the Body tab in Postman.
2. Select raw from the radio buttons (this allows you to
   send raw JSON).
3. Next to raw, choose JSON from the dropdown (this sets the
   Content-Type header to application/json).
4. In the Body text area, paste the JSON that you want to
   send to the Rails endpoint
   [this file](app/assets/json_file/example_json.json)'s
   content

#### Click Send

Postman will display the response at the bottom of the
screen with a JSON response that looks like this:

```bash
    {
        "spam": true,
        "virus": true,
        "dns": true,
        "month": "September",
        "delayed": false,
        "transmitter": "61967230-7A45-4A9D-BEC9-87CBCF2211C9",
        "receiver": [
            "recipient"
        ]
    }
```

### 5. Running tests

To run the rspec tests just run:

```bash
bundle exec rspec
```

Or if you're using a recent ruby version just:

```bash
rspec
```
