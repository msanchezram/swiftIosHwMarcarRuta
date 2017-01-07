//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Marcos on 7/1/17.
//  Copyright © 2017 MSR. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,  CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapa: MKMapView!
    
    let manejador = CLLocationManager()
    
    var miposicion = CLLocation()
    var distanciaRecorrida = 0
    
    var primeraLectura = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedWhenInUse){
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
            //ponemos en mapa en nuestra ubicacion
            mapa.centerCoordinate = (manager.location?.coordinate)!
            
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //aqui leemos las lecturas
        //if (manager.location.)
        
        if (!primeraLectura) {
            miposicion = manager.location!
            primeraLectura = true
        }
        
        let distancia = manager.location!.distance(from: miposicion)
        
        if (Int (distancia) > 50){
            miposicion = manager.location!
            distanciaRecorrida += Int (distancia)
            
            var punto = CLLocationCoordinate2D()
            punto.latitude = manager.location!.coordinate.latitude
            punto.longitude = manager.location!.coordinate.longitude
            
            let pin = MKPointAnnotation()
            pin.title="latitud \(punto.latitude), longitud \(punto.longitude)"
            pin.subtitle="Distancia recorrida: \(distanciaRecorrida) metros"
            pin.coordinate = punto
            
            mapa.addAnnotation(pin)
            
        }

        
        //print("lat: \(manager.location!.coordinate.latitude), long \(manager.location!.coordinate.longitude), distancia de la ubicacion inicial \(distancia)) ")
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("Hay error en la lectura")
       
        let alertController = UIAlertController(title: "Error", message:
            "Ha habido un error con la lectura de posicionamiento.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressButtonSatelite(_ sender: Any) {
        mapa.mapType=MKMapType.satellite
    }

    @IBAction func pressButtonEstandar(_ sender: Any) {
        mapa.mapType=MKMapType.standard
    }

    @IBAction func pressButtonHibrido(_ sender: Any) {
        mapa.mapType=MKMapType.hybrid
    }
    
    @IBAction func pressButtonZoomPlus(_ sender: Any) {
        
        let span = MKCoordinateSpan(latitudeDelta: mapa.region.span.latitudeDelta/2, longitudeDelta: mapa.region.span.longitudeDelta/2)
    
            
        
        let region = MKCoordinateRegion(center: mapa.region.center, span: span)
        
        
        mapa.setRegion(region, animated: true)

    }
    
    @IBAction func pressButtonZoomOut(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: mapa.region.span.latitudeDelta*2, longitudeDelta: mapa.region.span.longitudeDelta*2)
        
        
        
        let region = MKCoordinateRegion(center: mapa.region.center, span: span)
        
        
        mapa.setRegion(region, animated: true)
    }
    
}

