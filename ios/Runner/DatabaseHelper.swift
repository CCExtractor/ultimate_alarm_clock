import FMDB

class DatabaseHelper {
    var database: FMDatabase?

    init() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("alarms.db")

        database = FMDatabase(path: fileURL.path)

        if database?.open() == true {
            NSLog("Log:Database connected")
        } else {
            NSLog("Log:Database connection failed")
        }
    }
}
