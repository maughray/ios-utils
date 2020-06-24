import UIKit

class ObservableObject<T>
{
    struct Observer
    {
        weak var instance: AnyObject?
        var id: ObjectIdentifier
    }
    
    private var _observers: [Observer] = []
    public var observers: [T] {
        get {
            _observers.removeAll(where: { $0.instance == nil })
            
            var result: [T] = []
            for observer in _observers {
                if let instance = observer.instance as? T {
                    result.append(instance)
                }
            }
            return result
        }
    }
    
    func addObserver(_ subscriber: T)
    {
        let id = ObjectIdentifier(subscriber as AnyObject)
        if !_observers.contains(where: { $0.id == id })
        {
            let observer = Observer(instance: subscriber as AnyObject, id: id)
            _observers.append(observer)
        }
    }

    func removeObserver(_ subscriber: AnyObject)
    {
        let id = ObjectIdentifier(subscriber)
        _observers.removeAll(where: { $0.id == id })
    }
}
