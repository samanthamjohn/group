## modocache/group

### API

```
// GET /api/v1/posts.json
{
  "posts": [
    {
      "id": "41e98ae5-4c33-496a-a585-3d48d7670ae3",
      "title": "mathematical * 1!",
      "body": "It's gonna be so flippin' awesome.",
      "user": {
        "created_at": "2012-10-08T05: 07: 49Z",
        "email": "finn-the-human-3@land-of-ooo.ooo",
        "id": "90e56250-1098-4591-b5f0-2343c7da0fdd",
        "updated_at": "2012-10-08T05: 07: 49Z"
      },
      "created_at": "2012-10-08T05: 07: 49Z",
      "updated_at": "2012-10-08T05: 07: 49Z",
      "permissions": {
        "update": true,
        "destroy": true
      }
    }
  ]
}
```

```
// GET /api/v1/posts/:id.json
{
  "post": {
    "id": "2a01fdd3-9c3b-47be-b07c-f1c4beaf9e52",
    "title": "mathematical * 3!",
    "body": "It's gonna be so flippin' awesome.",
    "user": {
      "created_at": "2012-10-08T05:14:19Z",
      "email": "finn-the-human-7@land-of-ooo.ooo",
      "id": "90e56250-1098-4591-b5f0-2343c7da0fdd",
      "updated_at": "2012-10-08T05:14:19Z"
    },
    "created_at": "2012-10-08T05:14:19Z",
    "updated_at": "2012-10-08T05:14:19Z",
    "permissions": {
      "update": false,
      "destroy": false
    }
  }
}
```

```
// PUT /api/v1/posts/:id.json
// If any errors occur:
{
  "errors": {
    "title": [
      "is already taken"
    ]
  }
}
```
