$URI = 
$JSON = @{
  "@type"    = "MessageCard"
  "@context" = "<http://schema.org/extensions>"
  "title"    = 'Test Card Title'
  "text"     = 'Typically used to describe the purpose of the card.'
  "sections" = @(
    @{
      "activityTitle"    = 'Test Section'
      "activitySubtitle" = 'Section Subtitle'
      "activityText"     = 'Descriptive text for the activity.'
    }
  )
} | ConvertTo-JSON

# You will always be sending content in via POST and using the ContentType of 'application/json'
# The URI will be the URL that you previously retrieved when creating the webhook
$Params = @{
  "URI"         = $URI
  "Method"      = 'POST'
  "Body"        = $JSON
  "ContentType" = 'application/json'
}

Invoke-RestMethod @Params
