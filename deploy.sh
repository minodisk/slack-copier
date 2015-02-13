npm run build
npm run bump
zip -r $FILE_NAME dest
curl \
  -H "Authorization: Bearer $TOKEN"  \
  -H "x-goog-api-version: 2" \
  -X PUT \
  -T $FILE_NAME \
  -v \
  https://www.googleapis.com/upload/chromewebstore/v1.1/items/$APP_ID
