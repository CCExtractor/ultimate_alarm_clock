package com.pravera.fl_location.service

interface ServiceProvider {
	fun getLocationPermissionManager(): LocationPermissionManager
	fun getLocationDataProviderManager(): LocationDataProviderManager
	fun getLocationServicesStatusWatcher(): LocationServicesStatusWatcher
}
