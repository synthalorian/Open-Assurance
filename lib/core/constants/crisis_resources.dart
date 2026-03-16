/// Crisis resources and emergency hotlines
/// Real resources for people in need
class CrisisResources {
  CrisisResources._();
  
  static const List<CrisisResource> emergencyHotlines = [
    CrisisResource(
      name: '988 Suicide \u0026 Crisis Lifeline',
      phone: '988',
      description: 'Free, confidential support 24/7',
      country: 'United States',
    ),
    CrisisResource(
      name: 'Crisis Text Line',
      phone: 'Text HOME to 741741',
      description: 'Free crisis support via text',
      country: 'United States',
    ),
    CrisisResource(
      name: 'Samaritans',
      phone: '116 123',
      description: '24/7 listening service',
      country: 'United Kingdom',
    ),
    CrisisResource(
      name: 'Lifeline Australia',
      phone: '13 11 14',
      description: '24/7 crisis support',
      country: 'Australia',
    ),
    CrisisResource(
      name: 'Kids Help Phone',
      phone: '1-800-668-6868',
      description: 'Support for youth under 20',
      country: 'Canada',
    ),
    CrisisResource(
      name: 'Telefonseelsorge',
      phone: '0800 111 0 111',
      description: '24/7 emotional support',
      country: 'Germany',
    ),
    CrisisResource(
      name: 'SOS Amitié',
      phone: '09 72 39 40 50',
      description: '24/7 listening service',
      country: 'France',
    ),
    CrisisResource(
      name: '113 Suicide Prevention',
      phone: '0800-0113',
      description: '24/7 crisis support',
      country: 'Netherlands',
    ),
  ];
  
  static const List<CrisisResource> internationalResources = [
    CrisisResource(
      name: 'Befrienders Worldwide',
      phone: 'befrienders.org',
      description: 'Find a helpline in your country',
      country: 'International',
      isWebsite: true,
    ),
    CrisisResource(
      name: 'IASP - International Association for Suicide Prevention',
      phone: 'iasp.info',
      description: 'Resources and crisis centers worldwide',
      country: 'International',
      isWebsite: true,
    ),
    CrisisResource(
      name: 'Find A Helpline',
      phone: 'findahelpline.com',
      description: 'Search for helplines by country',
      country: 'International',
      isWebsite: true,
    ),
  ];
  
  static const List<CrisisResource> textChatResources = [
    CrisisResource(
      name: 'Crisis Text Line (US)',
      phone: 'Text HOME to 741741',
      description: 'Crisis support via text message',
      country: 'United States',
    ),
    CrisisResource(
      name: 'Shout (UK)',
      phone: 'Text SHOUT to 85258',
      description: '24/7 crisis text line',
      country: 'United Kingdom',
    ),
    CrisisResource(
      name: 'Lifeline Text (AU)',
      phone: '0477 13 11 14',
      description: 'Text-based crisis support',
      country: 'Australia',
    ),
  ];
  
  static const String emergencyDisclaimer = 
      'If you or someone you know is in immediate danger, '
      'please call your local emergency number (911, 999, 112, etc.) '
      'or go to your nearest emergency room.';
  
  static const String supportMessage = 
      'You matter. Your feelings are valid. '
      'There are people who want to help you through this.';
}

class CrisisResource {
  final String name;
  final String phone;
  final String description;
  final String country;
  final bool isWebsite;
  
  const CrisisResource({
    required this.name,
    required this.phone,
    required this.description,
    required this.country,
    this.isWebsite = false,
  });
}
