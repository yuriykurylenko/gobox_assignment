app = require('.././app')

app.service 'Uploadcare', ($q)  ->
  new class Uploadcare

    upload: (callback, cropRatio) ->
      uploadcarePromise = $q.defer()

      uploadcare.start
        crop: if cropRatio then cropRatio else 'enabled'
        previewStep: true
        imagesOnly: true
        tabs: 'file url dropbox flickr facebook instagram gdrive skydrive evernote box'

      uploadcareDialog = uploadcare.openDialog(null)

      uploadcareDialog.done (file) ->
        file.done (fileInfo) ->
          uploadcarePromise.resolve(fileInfo)
      .fail () ->
        uploadcarePromise.reject()

      uploadcarePromise
