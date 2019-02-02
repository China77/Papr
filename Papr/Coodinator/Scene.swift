//
//  Scene.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit

/**
     Refers to a screen managed by a view controller.
     It can be a regular screen, or a modal dialog.
     It comprises a view controller and a view model.
 */

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case papr
    case login(LoginViewModel)
    case alert(AlertViewModel)
    case activity([Any])
    case photoDetails(PhotoDetailsViewModel)
    case addToCollection(AddToCollectionViewModel)
    case createCollection(CreateCollectionViewModel)
    case searchPhotos(SearchPhotosViewModel)
    case searchCollections(SearchCollectionsViewModel)
    case searchUsers(SearchUsersViewModel)
    case userProfile(UserProfileViewModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .papr:
            let paprTabBarController = PaprTabBarController()

            //HomeViewController
            var homeVC = HomeViewController(collectionViewLayout: PinterestLayout())
            let homeViewModel = HomeViewModel()
            let rootHomeVC = PaprNavigationController(rootViewController: homeVC)
            homeVC.bind(to: homeViewModel)

            //SearchViewController
            var searchVC = SearchViewController.initFromNib()
            let searchViewModel = SearchViewModel()
            let rootSearchVC = PaprNavigationController(rootViewController: searchVC)
            searchVC.bind(to: searchViewModel)

            //CollectionsViewController
            var collectionsVC = CollectionsViewController()
            let collectionViewModel = CollectionsViewModel()
            let rootCollectionVC = PaprNavigationController(rootViewController: collectionsVC)
            collectionsVC.bind(to: collectionViewModel)

            rootHomeVC.tabBarItem = UITabBarItem(
                title: "Photos",
                image: UIImage(named: "photo-white"),
                tag: 0
            )

            rootCollectionVC.tabBarItem = UITabBarItem(
                title: "Collections",
                image: UIImage(named: "collections-white"),
                tag: 1
            )

            rootSearchVC.tabBarItem = UITabBarItem(
                title: "Search",
                image: UIImage(named: "search-white"),
                tag: 2
            )

            paprTabBarController.viewControllers = [
                rootHomeVC,
                rootCollectionVC,
                rootSearchVC
            ]

            return .tabBar(paprTabBarController)
        case let .login(viewModel):
            var vc = LoginViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return .alert(vc)
        case let .activity(items):
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return .alert(vc)
        case let .photoDetails(viewModel):
            var vc = PhotoDetailsViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .addToCollection(viewModel):
            var vc = AddToCollectionViewController.initFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .createCollection(viewModel):
            var vc = CreateCollectionViewController.initFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .searchPhotos(viewModel):
            var vc = SearchPhotosViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 2))
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchCollections(viewModel):
            var vc = SearchCollectionsViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchUsers(viewModel):
            var vc = SearchUsersViewController()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .userProfile(viewModel):
            var vc = UserProfileViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        }
    }
}

