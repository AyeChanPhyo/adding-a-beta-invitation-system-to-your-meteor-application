###
  Invites
  Collection of methods for updating documents in the Invites collection.
###

Meteor.methods(

  sendInvite: (invitee) ->
    # Check the invitee argument against our expected pattern.
    check(invitee,{id: String, email: String})

    # Generate a token here so we can use it with our email, too.
    token = Random.hexString(10)

    # Perform the insert into our DB.
    Invites.upsert(invitee,
      $set:
        token: token
        dateInvited: ( new Date() ).getTime()
        invited: true
        accountCreated: false
    ,(error)->
      if error
        console.log error
      else
        # If no errors, send the user an email with their invitation.
        Email.send(
          to: invitee.email
          from: "Widgetly Beta Invitation <beta@widgetly.com>"
          subject: "Welcome to the Widgetly Beta!"
          html: Handlebars.templates['send-invite'](
            token: token
          )
        )
    )
)