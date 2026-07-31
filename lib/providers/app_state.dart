import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/trip_model.dart';
import '../models/dhaba_model.dart';
import '../models/menu_item_model.dart';
import '../models/food_order_model.dart';
import '../models/mechanic_model.dart';
import '../models/mechanic_request_model.dart';
import '../models/sos_alert_model.dart';
import '../models/loyalty_reward_model.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService apiService = ApiService();

  // App Localization Preference (Default English: en, selectable on first launch & remembered)
  Locale appLocale = const Locale('en');
  bool hasUserSelectedLanguage = false;

  void setLocale(Locale newLocale) {
    appLocale = newLocale;
    hasUserSelectedLanguage = true;
    notifyListeners();
  }

  // Current User & Active Persona Role
  UserModel currentUser = UserModel(
    id: 'usr_001',
    name: 'Rajesh Singh',
    phone: '+91 98765 43210',
    email: 'rajesh.driver@highway.in',
    role: UserRole.driver,
    vehicleNumber: 'HR 26 DQ 8821',
    vehicleType: '12-Wheeler Truck (Tata)',
    businessName: 'Singh Freight Express',
  );

  // Loyalty Points & Stats
  int loyaltyPoints = 340;
  double totalKmDriven = 5420.0;
  int completedTripsCount = 18;

  // Active Trip State
  TripModel? activeTrip;
  List<TripModel> tripHistory = [];

  // Dhabas & Menu
  List<DhabaModel> dhabas = [];
  List<MenuItemModel> allMenuItems = [];

  // Cart & Food Orders
  List<OrderCartItem> cart = [];
  List<FoodOrderModel> foodOrders = [];

  // Mechanics & Breakdown Requests
  List<MechanicModel> mechanics = [];
  List<MechanicRequestModel> mechanicRequests = [];

  // SOS & Emergency
  List<SOSAlertModel> sosAlerts = [];
  List<EmergencyContact> emergencyContacts = [];

  // Loyalty Rewards
  List<LoyaltyRewardModel> loyaltyRewards = [];

  AppState() {
    _initMockData();
    _fetchBackendData();
  }

  Future<void> _fetchBackendData() async {
    final remoteDhabas = await apiService.fetchDhabas();
    if (remoteDhabas != null && remoteDhabas.isNotEmpty) {
      notifyListeners();
    }
  }

  void _initMockData() {
    // Active Trip Mock
    activeTrip = TripModel(
      id: 'trip_101',
      driverId: currentUser.id,
      origin: 'Delhi (Kashmere Gate)',
      destination: 'Jaipur (Transport Nagar)',
      totalKm: 280.0,
      drivenKm: 145.0,
      startTime: DateTime.now().subtract(const Duration(hours: 3)),
      status: TripStatus.active,
      waypoints: ['Gurugram', 'Neemrana', 'Kotputli'],
      pitstops: ['Sher-e-Punjab Dhaba', 'Highway King Mechanic Hub'],
    );

    tripHistory = [
      TripModel(
        id: 'trip_100',
        driverId: currentUser.id,
        origin: 'Ambala',
        destination: 'Delhi',
        totalKm: 210.0,
        drivenKm: 210.0,
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 2, hours: -5)),
        status: TripStatus.completed,
      ),
      TripModel(
        id: 'trip_099',
        driverId: currentUser.id,
        origin: 'Chandigarh',
        destination: 'Ludhiana',
        totalKm: 100.0,
        drivenKm: 100.0,
        startTime: DateTime.now().subtract(const Duration(days: 5)),
        endTime: DateTime.now().subtract(const Duration(days: 5, hours: -2)),
        status: TripStatus.completed,
      ),
    ];

    // Dhabas Mock with GPS Lat & Lng
    dhabas = [
      DhabaModel(
        id: 'dhaba_01',
        name: 'Sher-e-Punjab Dhaba & Restaurant',
        ownerId: 'owner_01',
        highway: 'NH 48 (Delhi - Jaipur Highway)',
        location: 'Km 122, Near Neemrana Toll Plaza',
        rating: 4.8,
        reviewCount: 420,
        isOpen: true,
        imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
        distanceKm: 4.2,
        latitude: 27.9812,
        longitude: 76.3811,
        amenities: ['Truck Parking', 'Clean Washroom', 'AC Hall', '24/7 Open', 'CCTV Security'],
        phone: '+91 99887 11223',
        timing: 'Open 24 Hours',
      ),
      DhabaModel(
        id: 'dhaba_02',
        name: 'Highway King Grand Dhaba',
        ownerId: 'owner_02',
        highway: 'NH 48 (Kotputli Bypass)',
        location: 'Km 160, Kotputli, Rajasthan',
        rating: 4.6,
        reviewCount: 310,
        isOpen: true,
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
        distanceKm: 28.5,
        latitude: 27.7011,
        longitude: 76.1200,
        amenities: ['Spacious Parking', 'Driver Rest Lounge', 'Hot Showers', 'RO Water'],
        phone: '+91 98123 45678',
        timing: '05:00 AM - 01:00 AM',
      ),
      DhabaModel(
        id: 'dhaba_03',
        name: 'Pavitra Shuddh Shakahari Dhaba',
        ownerId: 'owner_03',
        highway: 'NH 48 (Shahpura)',
        location: 'Shahpura, Rajasthan',
        rating: 4.4,
        reviewCount: 195,
        isOpen: true,
        imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500',
        distanceKm: 52.0,
        latitude: 27.4200,
        longitude: 75.9600,
        amenities: ['100% Pure Veg', 'Family Dining', 'Quick Parcel'],
        phone: '+91 97654 32109',
        timing: '06:00 AM - 11:30 PM',
      ),
    ];

    // Menu Items Mock
    allMenuItems = [
      MenuItemModel(
        id: 'm1',
        dhabaId: 'dhaba_01',
        name: 'Special Amritsari Butter Paneer',
        description: 'Rich cottage cheese cooked in buttery creamy tomato gravies with authentic spices.',
        price: 240.0,
        category: FoodCategory.mainCourse,
        isVeg: true,
        imageUrl: '',
        prepTimeMins: 15,
      ),
      MenuItemModel(
        id: 'm2',
        dhabaId: 'dhaba_01',
        name: 'Dal Makhani Special',
        description: 'Slow-cooked black lentils with white butter & cream.',
        price: 180.0,
        category: FoodCategory.mainCourse,
        isVeg: true,
        imageUrl: '',
        prepTimeMins: 12,
      ),
      MenuItemModel(
        id: 'm3',
        dhabaId: 'dhaba_01',
        name: 'Tandoori Butter Roti',
        description: 'Crispy clay oven bread brushed with pure Desi Ghee.',
        price: 20.0,
        category: FoodCategory.breads,
        isVeg: true,
        imageUrl: '',
        prepTimeMins: 5,
      ),
      MenuItemModel(
        id: 'm4',
        dhabaId: 'dhaba_01',
        name: 'Aloo Pyaz Stuffed Paratha with White Butter',
        description: 'Crispy whole wheat flatbread stuffed with spiced potatoes and onion.',
        price: 90.0,
        category: FoodCategory.breads,
        isVeg: true,
        imageUrl: '',
        prepTimeMins: 10,
      ),
      MenuItemModel(
        id: 'm5',
        dhabaId: 'dhaba_01',
        name: 'Kulhad Adrak Masala Chai',
        description: 'Strong highway cardamom ginger tea served in earthen clay cup.',
        price: 30.0,
        category: FoodCategory.beverages,
        isVeg: true,
        imageUrl: '',
        prepTimeMins: 5,
      ),
      MenuItemModel(
        id: 'm6',
        dhabaId: 'dhaba_01',
        name: 'Desi Chicken Curry (Dhaba Style)',
        description: 'Homestyle spicy highway chicken curry cooked with onion and garlic gravy.',
        price: 320.0,
        category: FoodCategory.mainCourse,
        isVeg: false,
        imageUrl: '',
        prepTimeMins: 20,
      ),
    ];

    // Mechanics Mock with GPS Lat & Lng
    mechanics = [
      MechanicModel(
        id: 'mech_01',
        name: 'Gurmeet Heavy Truck Repair & Vulcanizing',
        shopName: 'Gurmeet Automobile Works',
        phone: '+91 98888 77766',
        location: 'NH 48 Neemrana Flyover',
        rating: 4.9,
        distanceKm: 2.1,
        latitude: 27.9900,
        longitude: 76.3900,
        isAvailable: true,
        servicesOffered: [
          ServiceType.puncture,
          ServiceType.engine,
          ServiceType.towing,
          ServiceType.electrical,
        ],
        basePrice: 300.0,
      ),
      MechanicModel(
        id: 'mech_02',
        name: 'Jai Hanuman Breakdown Services',
        shopName: 'Hanuman Auto Clinic',
        phone: '+91 97777 55443',
        location: 'Shahjahanpur Border, NH 48',
        rating: 4.7,
        distanceKm: 12.0,
        latitude: 28.1100,
        longitude: 76.5000,
        isAvailable: true,
        servicesOffered: [
          ServiceType.puncture,
          ServiceType.fuelDelivery,
          ServiceType.generalCheckup,
        ],
        basePrice: 250.0,
      ),
    ];

    // Initial Orders
    foodOrders = [
      FoodOrderModel(
        id: 'ord_771',
        driverId: currentUser.id,
        driverName: currentUser.name,
        driverPhone: currentUser.phone,
        dhabaId: 'dhaba_01',
        dhabaName: 'Sher-e-Punjab Dhaba',
        items: [
          OrderCartItem(item: allMenuItems[0], quantity: 1),
          OrderCartItem(item: allMenuItems[2], quantity: 4),
          OrderCartItem(item: allMenuItems[4], quantity: 2),
        ],
        totalAmount: 380.0,
        status: OrderStatus.preparing,
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedPrepMins: 10,
      )
    ];

    // Initial Mechanic Requests
    mechanicRequests = [
      MechanicRequestModel(
        id: 'req_302',
        driverId: currentUser.id,
        driverName: currentUser.name,
        driverPhone: currentUser.phone,
        mechanicId: 'mech_01',
        mechanicName: 'Gurmeet Automobile Works',
        vehicleType: currentUser.vehicleType ?? 'Truck',
        vehicleNumber: currentUser.vehicleNumber ?? 'HR 26 DQ 8821',
        serviceType: ServiceType.puncture,
        issueDescription: 'Front left tire flat near Neemrana Toll Plaza. Need mobile vulcanizing.',
        locationAddress: 'Km 124, NH 48 Northbound',
        estimatedCost: 350.0,
        status: MechanicRequestStatus.onTheWay,
        requestTime: DateTime.now().subtract(const Duration(minutes: 25)),
      )
    ];

    // Emergency Contacts
    emergencyContacts = [
      EmergencyContact(name: 'Suresh Kumar (Transport Manager)', phone: '+91 98111 22233', relation: 'Employer'),
      EmergencyContact(name: 'Sunita Singh (Wife)', phone: '+91 99000 11223', relation: 'Family'),
      EmergencyContact(name: 'Highway Police Patrol', phone: '1033', relation: 'Helpline'),
    ];

    // Loyalty Rewards Mock
    loyaltyRewards = [
      LoyaltyRewardModel(
        id: 'rew_1',
        title: '₹100 Off on Dhaba Food',
        description: 'Valid at Sher-e-Punjab & Highway King Dhabas on minimum order ₹300.',
        pointsCost: 150,
        discountValue: 100.0,
        promoCode: 'HIGHWAY100',
      ),
      LoyaltyRewardModel(
        id: 'rew_2',
        title: 'Free Mechanic Inspection',
        description: 'Get free 15-point truck safety checkup at partner workshops.',
        pointsCost: 250,
        discountValue: 200.0,
        promoCode: 'FREECHECK200',
      ),
      LoyaltyRewardModel(
        id: 'rew_3',
        title: '₹250 Fuel Voucher',
        description: 'Redeem at IndianOil / BPCL partner highway fuel pumps.',
        pointsCost: 500,
        discountValue: 250.0,
        promoCode: 'FUEL250GIFT',
      ),
    ];
  }

  // Role Switcher
  void switchUserRole(UserRole newRole) {
    currentUser = currentUser.copyWith(role: newRole);
    notifyListeners();
  }

  // Trip Management
  void startNewTrip(String origin, String destination, double distanceKm) {
    activeTrip = TripModel(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      driverId: currentUser.id,
      origin: origin,
      destination: destination,
      totalKm: distanceKm,
      drivenKm: 0.0,
      startTime: DateTime.now(),
      status: TripStatus.active,
    );
    notifyListeners();
  }

  void updateTripProgress(double additionalKm) {
    if (activeTrip != null) {
      final newDriven = activeTrip!.drivenKm + additionalKm;
      activeTrip = activeTrip!.copyWith(drivenKm: newDriven);
      totalKmDriven += additionalKm;
      // Award 1 point per 5 km
      loyaltyPoints += (additionalKm / 5).round();
      notifyListeners();
    }
  }

  void completeActiveTrip() {
    if (activeTrip != null) {
      final completed = activeTrip!.copyWith(
        status: TripStatus.completed,
        endTime: DateTime.now(),
      );
      tripHistory.insert(0, completed);
      completedTripsCount++;
      activeTrip = null;
      notifyListeners();
    }
  }

  // Food Order Cart Management
  void addToCart(MenuItemModel item) {
    final index = cart.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(OrderCartItem(item: item, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(MenuItemModel item) {
    final index = cart.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double get cartTotalAmount {
    return cart.fold(0.0, (sum, c) => sum + c.totalPrice);
  }

  void placeFoodOrder(String dhabaId, String dhabaName, String paymentMethod) {
    if (cart.isEmpty) return;

    final newOrder = FoodOrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      driverId: currentUser.id,
      driverName: currentUser.name,
      driverPhone: currentUser.phone,
      dhabaId: dhabaId,
      dhabaName: dhabaName,
      items: List.from(cart),
      totalAmount: cartTotalAmount,
      status: OrderStatus.pending,
      orderTime: DateTime.now(),
      paymentMethod: paymentMethod,
    );

    foodOrders.insert(0, newOrder);
    apiService.createOrder({
      'dhabaId': dhabaId,
      'items': cart.map((c) => {'id': c.item.id, 'quantity': c.quantity}).toList(),
      'totalAmount': cartTotalAmount,
      'paymentMethod': paymentMethod,
    });

    loyaltyPoints += (cartTotalAmount / 10).round();
    clearCart();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = foodOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      foodOrders[index] = foodOrders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Mechanic Breakdown Requests
  void requestMechanicService({
    required MechanicModel mechanic,
    required ServiceType serviceType,
    required String issueDescription,
    required String locationAddress,
  }) {
    final newReq = MechanicRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      driverId: currentUser.id,
      driverName: currentUser.name,
      driverPhone: currentUser.phone,
      mechanicId: mechanic.id,
      mechanicName: mechanic.shopName,
      vehicleType: currentUser.vehicleType ?? 'Truck',
      vehicleNumber: currentUser.vehicleNumber ?? 'HR 26 DQ 8821',
      serviceType: serviceType,
      issueDescription: issueDescription,
      locationAddress: locationAddress,
      estimatedCost: serviceType.defaultEstimatedCost,
      status: MechanicRequestStatus.requested,
      requestTime: DateTime.now(),
    );

    mechanicRequests.insert(0, newReq);
    notifyListeners();
  }

  void updateMechanicRequestStatus(String reqId, MechanicRequestStatus newStatus) {
    final index = mechanicRequests.indexWhere((r) => r.id == reqId);
    if (index >= 0) {
      mechanicRequests[index] = mechanicRequests[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Emergency Panic SOS Trigger
  void triggerPanicSOS(String currentAddress) {
    final newSOS = SOSAlertModel(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      driverId: currentUser.id,
      driverName: currentUser.name,
      driverPhone: currentUser.phone,
      locationAddress: currentAddress,
      latitude: 27.9812,
      longitude: 76.3811,
      timestamp: DateTime.now(),
      status: SOSAlertStatus.active,
      notifiedContacts: emergencyContacts.map((c) => c.name).toList(),
    );

    sosAlerts.insert(0, newSOS);
    apiService.sendSOSAlert({
      'driverId': currentUser.id,
      'address': currentAddress,
      'lat': 27.9812,
      'lng': 76.3811,
    });

    notifyListeners();
  }

  void resolveSOSAlert(String sosId) {
    final index = sosAlerts.indexWhere((s) => s.id == sosId);
    if (index >= 0) {
      sosAlerts[index] = sosAlerts[index].copyWith(status: SOSAlertStatus.resolved);
      notifyListeners();
    }
  }

  void addEmergencyContact(String name, String phone, String relation) {
    emergencyContacts.add(EmergencyContact(name: name, phone: phone, relation: relation));
    notifyListeners();
  }

  // Redeem Reward
  void redeemLoyaltyReward(String rewardId) {
    final index = loyaltyRewards.indexWhere((r) => r.id == rewardId);
    if (index >= 0) {
      final reward = loyaltyRewards[index];
      if (loyaltyPoints >= reward.pointsCost && !reward.isRedeemed) {
        loyaltyPoints -= reward.pointsCost;
        loyaltyRewards[index] = reward.copyWith(isRedeemed: true);
        notifyListeners();
      }
    }
  }
}
