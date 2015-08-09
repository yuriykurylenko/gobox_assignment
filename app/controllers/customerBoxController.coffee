_ = require('underscore')
uploaderService = require('.././services/uploadcareService')
uploaderDirective = require('.././directives/uploaderDirective')

app = require('.././app')

app.controller "CustomerBoxController", ($scope, $firebaseArray, $modal) ->
  customerBoxesRef = new Firebase("https://gobox-yk.firebaseio.com/customerboxes")
  $scope.customerBoxes = $firebaseArray(customerBoxesRef)

  $scope.itemsInStorage = () ->
    criteria = (customerBox) ->
      customerBox.status == 1 || customerBox.status == 3
    _.filter($scope.customerBoxes, criteria).length

  $scope.itemsAtHome = () ->
    criteria = (customerBox) ->
      customerBox.status == 2 || customerBox.status == 4
    _.filter($scope.customerBoxes, criteria).length

  $scope.numberBoxesChosen = () ->
    criteria = (customerBox) ->
      customerBox.status == 3 || customerBox.status == 4
    _.filter($scope.customerBoxes, criteria).length    

  $scope.orderCustomerBoxItem = (customerBox) ->
    customerBox.status = if customerBox.status == 1 then 3 else if customerBox.status == 2 then 4

  $scope.openCustomerBoxItem = (customerBox) ->
    $scope.selectedCustomerBox = customerBox

    $scope.slides = _.map customerBox.pictures_urls, (pictureUrls) ->
      { image: pictureUrls.desktop_picture_max_size_url }

    $scope.modalInstance = $modal.open
      animation: true
      templateUrl: 'editItem.html'
      scope: $scope

    $scope.modalInstance.result.finally () ->
      $scope.editingCustomerBoxItem = false
      $scope.selectedCustomerBox = null

    true

  $scope.editCustomerBoxItem = () ->
    $scope.editingCustomerBoxItem = true
    true

  $scope.previewCustomerBoxItem = () ->
    $scope.editingCustomerBoxItem = false
    true

  $scope.saveCustomerBoxItem = () ->
    recordtoSave = $scope.customerBoxes.$getRecord($scope.selectedCustomerBox.$id)
    $scope.customerBoxes.$save(recordtoSave).then () ->
      $scope.modalInstance.close()
    true

  $scope.$watch 'imageUploaded', () ->
    if $scope.selectedCustomerBox
      $scope.selectedCustomerBox.pictures_urls.push
        desktop_picture_thumbnail_url: $scope.imageUploaded.thumbnailSrc
        desktop_picture_max_size_url:  $scope.imageUploaded.imageSrc
    true
