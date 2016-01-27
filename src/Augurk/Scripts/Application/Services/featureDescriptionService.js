﻿/*
 Copyright 2014-2016, Mark Taling
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

angular.module('Augurk').factory('featureDescriptionService', ['$resource', function ($resource) {

    // The branchname might contain a period, which webapi only allows if you finish with a slash
    // Since AngularJS doesn't allow for trailing slashes, use a backslash instead
    var service = {
        getFeaturesByBranch: function (branch, callback) {
            $resource('api/features/:branchName\\', { branchName: '@branchName' })
                .query({ branchName: branch }, callback);
        },

        getFeaturesByBranchAndTag: function (branch, tag, callback) {
            $resource('api/tags/:branchName/:tag/features', { branchName: '@branchName', tag: '@tag' })
                .query({ branchName: branch, tag: tag }, callback);
        },

        getGroupsByProduct: function (product, callback) {
            $resource('api/v2/products/:productName/groups', { productName: '@productName' })
                .query({ productName: product }, callback);
        }
    };
    
    return service;
}]);