app = require('.././app')
uploadcare = require('uploadcare')

app.directive 'uploader', ['Uploadcare', (Uploadcare) ->
  restrict: 'AE'
  require: 'ngModel'
  template: '<button type="button" ng-click="uploadImage()" class="btn btn-success">Upload</button>'
  scope:
    aspectRatio: '@aspectRatio'
    imageWidth: '@imageWidth'
    imageHeight: '@imageHeight'    
    thumbnailWidth: '@thumbnailWidth'
    thumbnailHeight: '@thumbnailHeight'

  link: (scope, element, attrs, ngModel) ->
    setDimensions = (dimensions) ->
      dimensionsString = ''

      if dimensions.width && dimensions.height
        dimensionsString = dimensions.width + 'x' + dimensions.height
      else if dimensions.width
        dimensionsString = dimensions.width + 'x'
      else if dimensions.height
        dimensionsString = 'x' + dimensions.height

      dimensionsString


    successCallback = (fileInfo) ->
      scope.uploaded = true
      imageSrc =  fileInfo.cdnUrl + '-/resize/' + setDimensions({ width: scope.imageWidth, height: scope.imageHeight }) + '/'
      thumbnailSrc =  fileInfo.cdnUrl + '-/resize/' + setDimensions({ width: scope.thumbnailWidth, height: scope.thumbnailHeight }) + '/'
      
      ngModel.$setViewValue
        imageSrc: imageSrc
        thumbnailSrc: thumbnailSrc

    errorCallback = () ->
      scope.error = true

    scope.uploadImage = () ->
      Uploadcare.upload(null, scope.aspectRatio).promise.then(successCallback, errorCallback)

]
