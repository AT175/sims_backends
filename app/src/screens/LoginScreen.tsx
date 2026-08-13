import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ActivityIndicator,
  Alert,
  Image,
  Dimensions,
  Animated,
  Easing,
  ScrollView,
} from 'react-native';
import { useAuthStore } from '@store/authStore';
import { useRegistryStore } from '@store/registryStore';
import type { Programme, PaymentMethod } from '@store/registryStore';
import { PROGRAMMES } from '@store/registryStore';
import { colors, spacing, fontSize, fontWeight, radius, shadows } from '@theme/index';

type AdmissionStep = 'search' | 'payment' | 'form' | 'submitted';
type StatusStep = 'lookup' | 'result';

const { width: SCREEN_WIDTH } = Dimensions.get('window');
const BANNER_ASPECT = 502 / 1724;
const HEADER_HEIGHT = Math.min(Math.round(SCREEN_WIDTH * BANNER_ASPECT), 260);

const INFO_SLIDES = [
  {
    image: '/slide1.jpg',
    title: 'Excellence in Education',
    text: 'Top-performing WASSCE students for over 25 years, with a 98% university placement rate.',
    accent: colors.primaryLight,
  },
  {
    image: '/slide2.jpg',
    title: 'Vibrant Campus Life',
    text: 'Inter-house sports, drama club, debate society, and STEM fairs — something for every student.',
    accent: colors.accent,
  },
  {
    image: '/slide3.jpg',
    title: 'Recent Achievements',
    text: '2025 Regional Athletics Champions · National Science Quiz semi-finalists · Best Debate Team.',
    accent: colors.success,
  },
  {
    image: '/slide4.jpg',
    title: 'Upcoming Events',
    text: 'Open Day — July 15 · Speech & Prize Giving — July 28 · GTU Exams begin August 5.',
    accent: colors.info,
  },
  {
    image: '/slide5.jpg',
    title: 'Our Community',
    text: 'Over 1,800 students, 120 dedicated staff, and a thriving PTA working together for success.',
    accent: colors.purple || colors.primaryLight,
  },
];

const PANEL_BG_IMAGES = ['/bg6.jpg', '/bg7.jpg', '/bg8.jpg'];

export function LoginScreen() {
  const { login, loginTemp, isLoading, error, clearError } = useAuthStore();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const [showLoginForm, setShowLoginForm] = useState(false);
  const [showAdmissionForm, setShowAdmissionForm] = useState(false);
  const [showStatusCheck, setShowStatusCheck] = useState(false);

  // Admission application flow
  const [admissionStep, setAdmissionStep] = useState<AdmissionStep>('search');
  const [wardName, setWardName] = useState('');
  const [placementRef, setPlacementRef] = useState('');
  const [parentName, setParentName] = useState('');
  const [parentPhone, setParentPhone] = useState('');
  const [parentEmail, setParentEmail] = useState('');
  const [selectedProgramme, setSelectedProgramme] = useState<Programme>('Science');
  const [matchedPlacement, setMatchedPlacement] = useState<any>(null);
  const [admissionLoading, setAdmissionLoading] = useState(false);

  // Payment flow
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod | null>(null);
  const [mmNumber, setMmNumber] = useState('');
  const [mmRef, setMmRef] = useState('');
  const [scratchPin, setScratchPin] = useState('');
  const [scratchSerial, setScratchSerial] = useState('');

  // Status check flow
  const [statusStep, setStatusStep] = useState<StatusStep>('lookup');
  const [statusName, setStatusName] = useState('');
  const [statusRef, setStatusRef] = useState('');
  const [statusResult, setStatusResult] = useState<any>(null);

  // ── Info carousel animation ──
  const [slideIndex, setSlideIndex] = useState(0);
  const fadeAnim = useRef(new Animated.Value(1)).current;
  const slideAnim = useRef(new Animated.Value(0)).current;

  // ── Panel background animation ──
  const [loginBgIndex, setLoginBgIndex] = useState(0);
  const [admissionBgIndex, setAdmissionBgIndex] = useState(1);
  const loginBgFade = useRef(new Animated.Value(0.15)).current;
  const admissionBgFade = useRef(new Animated.Value(0.15)).current;

  useEffect(() => {
    const interval = setInterval(() => {
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 0,
          duration: 400,
          useNativeDriver: true,
          easing: Easing.ease,
        }),
        Animated.timing(slideAnim, {
          toValue: -20,
          duration: 400,
          useNativeDriver: true,
          easing: Easing.ease,
        }),
      ]).start(() => {
        setSlideIndex((prev) => (prev + 1) % INFO_SLIDES.length);
        slideAnim.setValue(20);
        Animated.parallel([
          Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 500,
            useNativeDriver: true,
            easing: Easing.out(Easing.ease),
          }),
          Animated.timing(slideAnim, {
            toValue: 0,
            duration: 500,
            useNativeDriver: true,
            easing: Easing.out(Easing.ease),
          }),
        ]).start();
      });
    }, 4000);
    return () => clearInterval(interval);
  }, [fadeAnim, slideAnim]);

  // ── Panel background crossfade ──
  useEffect(() => {
    const loginInterval = setInterval(() => {
      Animated.timing(loginBgFade, {
        toValue: 0,
        duration: 600,
        useNativeDriver: true,
        easing: Easing.ease,
      }).start(() => {
        setLoginBgIndex((prev) => (prev + 1) % PANEL_BG_IMAGES.length);
        Animated.timing(loginBgFade, {
          toValue: 0.15,
          duration: 800,
          useNativeDriver: true,
          easing: Easing.out(Easing.ease),
        }).start();
      });
    }, 6000);
    return () => clearInterval(loginInterval);
  }, [loginBgFade]);

  useEffect(() => {
    const admissionInterval = setInterval(() => {
      Animated.timing(admissionBgFade, {
        toValue: 0,
        duration: 600,
        useNativeDriver: true,
        easing: Easing.ease,
      }).start(() => {
        setAdmissionBgIndex((prev) => (prev + 1) % PANEL_BG_IMAGES.length);
        Animated.timing(admissionBgFade, {
          toValue: 0.15,
          duration: 800,
          useNativeDriver: true,
          easing: Easing.out(Easing.ease),
        }).start();
      });
    }, 7000);
    return () => clearInterval(admissionInterval);
  }, [admissionBgFade]);

  const handleLogin = async () => {
    if (!username.trim() || !password.trim()) {
      Alert.alert('Error', 'Please enter your username and password');
      return;
    }

    const trimmedUsername = username.trim();
    const trimmedPassword = password.trim();

    // Check if this might be a temp credential (starts with VOTER_)
    if (trimmedUsername.startsWith('VOTER_')) {
      try {
        await loginTemp(trimmedUsername, trimmedPassword);
        // Temp login successful - will be handled by auth store to redirect
        return;
      } catch (tempError) {
        // Temp login failed, try regular login
        console.log('Temp login failed, trying regular login');
      }
    }

    // Try regular login
    login(trimmedUsername, trimmedPassword);
  };

  const registryStore = useRegistryStore();

  const handleAdmissionSearch = () => {
    if (!wardName.trim()) {
      Alert.alert('Error', 'Please enter your ward\'s name');
      return;
    }
    const placement = registryStore.searchPlacement(wardName.trim());
    if (placement) {
      setMatchedPlacement(placement);
      setPlacementRef(placement.csspsRef);
      setSelectedProgramme(placement.programme);
      setAdmissionStep('payment');
    } else {
      setMatchedPlacement(null);
      setAdmissionStep('payment');
    }
  };

  const handlePaymentSubmit = () => {
    if (!paymentMethod) {
      Alert.alert('Error', 'Please select a payment method');
      return;
    }
    if (paymentMethod === 'Mobile Money') {
      if (!mmNumber.trim() || !mmRef.trim()) {
        Alert.alert('Error', 'Please enter your mobile money number and transaction reference');
        return;
      }
      setAdmissionStep('form');
    } else {
      if (!scratchPin.trim() || !scratchSerial.trim()) {
        Alert.alert('Error', 'Please enter the scratch card PIN and serial number');
        return;
      }
      const card = registryStore.validateScratchCard(scratchPin.trim(), scratchSerial.trim(), wardName.trim());
      if (!card) {
        Alert.alert('Error', 'Invalid or already used scratch card. Please check your PIN and serial number.');
        return;
      }
      setMmRef(card.serial);
      setAdmissionStep('form');
    }
  };

  const handleAdmissionSubmit = () => {
    if (!parentName.trim() || !parentPhone.trim()) {
      Alert.alert('Error', 'Parent name and phone are required');
      return;
    }
    setAdmissionLoading(true);
    registryStore.addAdmission({
      applicantName: wardName.trim(),
      parentName: parentName.trim(),
      parentPhone: parentPhone.trim(),
      parentEmail: parentEmail.trim(),
      programme: selectedProgramme,
      photoUrl: null,
      csspsRef: placementRef.trim() || null,
      notes: '',
      fee: {
        amount: registryStore.applicationFeeAmount,
        method: paymentMethod!,
        status: 'Paid',
        reference: paymentMethod === 'Mobile Money' ? mmRef.trim() : scratchSerial.trim(),
        paidAt: new Date().toISOString().slice(0, 10),
        verifiedBy: null,
      },
    } as any);
    setAdmissionLoading(false);
    setAdmissionStep('submitted');
  };

  const handleStatusCheck = () => {
    if (!statusName.trim() || !statusRef.trim()) {
      Alert.alert('Error', 'Please enter both name and CSSPS reference');
      return;
    }
    const admission = registryStore.getAdmissionByCredentials(statusName.trim(), statusRef.trim());
    if (!admission) {
      Alert.alert('Not Found', 'No application found with the provided details. Please check and try again.');
      return;
    }
    setStatusResult(admission);
    setStatusStep('result');
  };

  const resetAdmissionFlow = () => {
    setAdmissionStep('search');
    setWardName('');
    setPlacementRef('');
    setParentName('');
    setParentPhone('');
    setParentEmail('');
    setSelectedProgramme('Science');
    setMatchedPlacement(null);
    setPaymentMethod(null);
    setMmNumber('');
    setMmRef('');
    setScratchPin('');
    setScratchSerial('');
    setShowAdmissionForm(false);
  };

  const resetStatusFlow = () => {
    setStatusStep('lookup');
    setStatusName('');
    setStatusRef('');
    setStatusResult(null);
    setShowStatusCheck(false);
  };

  return (
    <View style={styles.screen}>
      {/* ── HEADER ── Full-width banner image */}
      <View style={styles.header}>
        <Image
          source={{ uri: '/banner3.png' }}
          style={styles.headerImage}
          resizeMode="cover"
        />
        {/* Dark gradient overlay for readability */}
        <View style={styles.headerOverlay} />
        {/* Brand overlay on the banner */}
        <View style={styles.headerBrand}>
          <View style={styles.logoRing}>
            <View style={styles.logoInner}>
              <Text style={styles.logoText}>SIMS</Text>
            </View>
          </View>
          <Text style={styles.brandTitle}>School Information{'\n'}Management System</Text>
          <Text style={styles.brandTagline}>Empowering Ghanaian Senior High Schools</Text>
        </View>
      </View>

      {/* ── BODY ── Two compact buttons side-by-side, expand on click */}
      <View style={styles.body}>
        {/* ── LEFT: Login ── */}
        {showLoginForm ? (
          <View style={styles.glassCard}>
            <View style={styles.cardHeaderAccent} />
            <TouchableOpacity
              style={styles.expandButton}
              onPress={() => setShowLoginForm(false)}
              activeOpacity={0.85}
            >
              <View style={styles.expandButtonLeft}>
                <View style={styles.panelIconWrap}>
                  <Text style={styles.panelIconText}>
                  </Text>
                </View>
                <View>
                  <Text style={styles.expandButtonTitle}>Sign In</Text>
                  <Text style={styles.expandButtonSubtitle}>Access your dashboard</Text>
                </View>
              </View>
              <Text style={styles.chevron}>▴</Text>
            </TouchableOpacity>

            <ScrollView style={styles.formBody} showsVerticalScrollIndicator={false} contentContainerStyle={styles.formBodyContent}>
              {error && (
                <View style={styles.errorBox}>
                  <View style={styles.errorIconWrap}>
                    <Text style={styles.errorIcon}>!</Text>
                  </View>
                  <Text style={styles.errorText}>{error}</Text>
                  <TouchableOpacity onPress={clearError} style={styles.errorDismissBtn}>
                    <Text style={styles.errorDismiss}>✕</Text>
                  </TouchableOpacity>
                </View>
              )}

              <Text style={styles.label}>Username</Text>
              <View style={styles.inputWrap}>
                <TextInput
                  style={styles.input}
                  placeholder="Staff ID / Student ID / Username"
                  placeholderTextColor={colors.textLight}
                  value={username}
                  onChangeText={setUsername}
                  autoCapitalize="none"
                  autoCorrect={false}
                />
              </View>

              <Text style={styles.label}>Password</Text>
              <View style={styles.inputWrap}>
                <TextInput
                  style={styles.input}
                  placeholder="••••••••"
                  placeholderTextColor={colors.textLight}
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry
                  autoCapitalize="none"
                />
              </View>

              <TouchableOpacity
                style={[styles.loginButton, isLoading && styles.loginButtonDisabled]}
                onPress={handleLogin}
                disabled={isLoading}
                activeOpacity={0.85}
              >
                {isLoading ? (
                  <ActivityIndicator color={colors.white} />
                ) : (
                  <>
                    <Text style={styles.loginButtonText}>Sign In</Text>
                    <Text style={styles.loginButtonArrow}>→</Text>
                  </>
                )}
              </TouchableOpacity>

              <TouchableOpacity style={styles.forgotLink}>
                <Text style={styles.forgotPassword}>Forgot password?</Text>
              </TouchableOpacity>

            </ScrollView>
          </View>
        ) : (
          <View style={styles.collapsedWrap}>
            <Animated.Image
              source={{ uri: PANEL_BG_IMAGES[loginBgIndex] }}
              style={styles.collapsedBgImage}
              resizeMode="cover"
            />
            <View style={styles.collapsedBgOverlay} />
            <TouchableOpacity
              style={styles.collapsedButton}
              onPress={() => setShowLoginForm(true)}
              activeOpacity={0.85}
            >
              <View style={styles.collapsedButtonLeft}>
                <View style={styles.collapsedIconWrap}>
                  <Text style={styles.collapsedIconText}>
                  </Text>
                </View>
                <View>
                  <Text style={styles.collapsedTitle}>Sign In</Text>
                  <Text style={styles.collapsedSubtitle}>Access your dashboard</Text>
                </View>
              </View>
              <Text style={styles.collapsedChevron}>▾</Text>
            </TouchableOpacity>
          </View>
        )}

        {/* ── RIGHT: Admission / Status Check ── */}
        {showAdmissionForm ? (
          <View style={styles.glassCard}>
            <View style={[styles.cardHeaderAccent, { backgroundColor: colors.accent }]} />
            <TouchableOpacity
              style={styles.expandButton}
              onPress={resetAdmissionFlow}
              activeOpacity={0.85}
            >
              <View style={styles.expandButtonLeft}>
                <View style={[styles.panelIconWrap, { backgroundColor: colors.accent + '20' }]}>
                  <Text style={[styles.panelIconText, { color: colors.accentDark }]}>✎
                  </Text>
                </View>
                <View>
                  <Text style={styles.expandButtonTitle}>Apply for Admission</Text>
                  <Text style={styles.expandButtonSubtitle}>New student? Search for placement.</Text>
                </View>
              </View>
              <Text style={styles.chevron}>▴</Text>
            </TouchableOpacity>

            <View style={styles.formBody}>
              {admissionStep === 'search' && (
                <View>
                  <Text style={styles.label}>Ward's Full Name</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="Enter ward's name"
                      placeholderTextColor={colors.textLight}
                      value={wardName}
                      onChangeText={setWardName}
                    />
                  </View>

                  <Text style={styles.label}>CSSPS Placement Reference (optional)</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="e.g. CSSPS/2026/0451"
                      placeholderTextColor={colors.textLight}
                      value={placementRef}
                      onChangeText={setPlacementRef}
                      autoCapitalize="none"
                    />
                  </View>

                  <Text style={styles.privacyNotice}>
                    By continuing, you consent to the school collecting and processing the information provided for admission purposes. Parental consent is required for applicants under 18.
                  </Text>

                  <TouchableOpacity
                    style={styles.searchButton}
                    onPress={handleAdmissionSearch}
                    activeOpacity={0.85}
                  >
                    <Text style={styles.searchButtonText}>Search Placement</Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={[styles.searchButton, { backgroundColor: 'transparent', borderWidth: 1, borderColor: colors.accent, marginTop: spacing.sm }]}
                    onPress={() => { setShowAdmissionForm(false); setShowStatusCheck(true); }}
                    activeOpacity={0.85}
                  >
                    <Text style={[styles.searchButtonText, { color: colors.accent }]}>Check Admission Status</Text>
                  </TouchableOpacity>
                </View>
              )}

              {admissionStep === 'payment' && (
                <View>
                  {matchedPlacement && (
                    <View style={styles.matchBanner}>
                      <View style={styles.matchIconWrap}>
                        <Text style={styles.matchIcon}>✓</Text>
                      </View>
                      <Text style={styles.matchText}>
                        Placement found for "{wardName}". Programme: {matchedPlacement.programme}
                      </Text>
                    </View>
                  )}
                  {!matchedPlacement && (
                    <View style={styles.matchBanner}>
                      <View style={[styles.matchIconWrap, { backgroundColor: colors.warning + '20' }]}>
                        <Text style={[styles.matchIcon, { color: colors.warning }]}>!</Text>
                      </View>
                      <Text style={styles.matchText}>
                        No placement found for "{wardName}". You can still apply — the school will verify your placement.
                      </Text>
                    </View>
                  )}

                  <Text style={styles.stepTitle}>Step 1: Application Fee Payment</Text>
                  <Text style={styles.stepSubtitle}>Fee: GH₵{registryStore.applicationFeeAmount}</Text>

                  <Text style={styles.label}>Select Payment Method</Text>
                  <View style={styles.paymentMethodRow}>
                    <TouchableOpacity
                      style={[styles.paymentMethodCard, paymentMethod === 'Mobile Money' && styles.paymentMethodActive]}
                      onPress={() => setPaymentMethod('Mobile Money')}
                    >
                      <Text style={styles.paymentMethodIcon}>📱</Text>
                      <Text style={styles.paymentMethodLabel}>Mobile Money</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={[styles.paymentMethodCard, paymentMethod === 'Scratch Card' && styles.paymentMethodActive]}
                      onPress={() => setPaymentMethod('Scratch Card')}
                    >
                      <Text style={styles.paymentMethodIcon}>🎫</Text>
                      <Text style={styles.paymentMethodLabel}>Scratch Card</Text>
                    </TouchableOpacity>
                  </View>

                  {paymentMethod === 'Mobile Money' && (
                    <View>
                      <Text style={styles.label}>Mobile Money Number</Text>
                      <View style={styles.inputWrap}>
                        <TextInput
                          style={styles.input}
                          placeholder="024-XXX-XXXX"
                          placeholderTextColor={colors.textLight}
                          value={mmNumber}
                          onChangeText={setMmNumber}
                          keyboardType="phone-pad"
                        />
                      </View>
                      <Text style={styles.label}>Transaction Reference</Text>
                      <View style={styles.inputWrap}>
                        <TextInput
                          style={styles.input}
                          placeholder="Enter MM transaction ref"
                          placeholderTextColor={colors.textLight}
                          value={mmRef}
                          onChangeText={setMmRef}
                          autoCapitalize="none"
                        />
                      </View>
                    </View>
                  )}

                  {paymentMethod === 'Scratch Card' && (
                    <View>
                      <Text style={styles.label}>Scratch Card Serial</Text>
                      <View style={styles.inputWrap}>
                        <TextInput
                          style={styles.input}
                          placeholder="e.g. SC-002"
                          placeholderTextColor={colors.textLight}
                          value={scratchSerial}
                          onChangeText={setScratchSerial}
                          autoCapitalize="none"
                        />
                      </View>
                      <Text style={styles.label}>Scratch Card PIN</Text>
                      <View style={styles.inputWrap}>
                        <TextInput
                          style={styles.input}
                          placeholder="e.g. 2345-6789"
                          placeholderTextColor={colors.textLight}
                          value={scratchPin}
                          onChangeText={setScratchPin}
                          autoCapitalize="none"
                        />
                      </View>
                      <Text style={styles.hintText}>Demo cards: SC-002 / 2345-6789, SC-003 / 3456-7890, SC-004 / 4567-8901</Text>
                    </View>
                  )}

                  <View style={styles.stepNavRow}>
                    <TouchableOpacity style={styles.backBtn} onPress={() => setAdmissionStep('search')}>
                      <Text style={styles.backBtnText}>← Back</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.submitButton} onPress={handlePaymentSubmit} activeOpacity={0.85}>
                      <Text style={styles.submitButtonText}>Pay & Continue</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              )}

              {admissionStep === 'form' && (
                <View>
                  <View style={styles.matchBanner}>
                    <View style={styles.matchIconWrap}>
                      <Text style={styles.matchIcon}>✓</Text>
                    </View>
                    <Text style={styles.matchText}>Payment confirmed. Complete your application.</Text>
                  </View>

                  <Text style={styles.stepTitle}>Step 2: Application Form</Text>

                  <Text style={styles.label}>Programme</Text>
                  <View style={styles.paymentMethodRow}>
                    {PROGRAMMES.map((p) => (
                      <TouchableOpacity
                        key={p}
                        style={[styles.paymentMethodCard, selectedProgramme === p && styles.paymentMethodActive]}
                        onPress={() => setSelectedProgramme(p)}
                      >
                        <Text style={styles.paymentMethodLabel}>{p}</Text>
                      </TouchableOpacity>
                    ))}
                  </View>

                  <Text style={styles.label}>Parent / Guardian Name</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="Full name"
                      placeholderTextColor={colors.textLight}
                      value={parentName}
                      onChangeText={setParentName}
                    />
                  </View>

                  <Text style={styles.label}>Phone Number</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="024-XXX-XXXX"
                      placeholderTextColor={colors.textLight}
                      value={parentPhone}
                      onChangeText={setParentPhone}
                      keyboardType="phone-pad"
                    />
                  </View>

                  <Text style={styles.label}>Email (optional)</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="parent@example.com"
                      placeholderTextColor={colors.textLight}
                      value={parentEmail}
                      onChangeText={setParentEmail}
                      keyboardType="email-address"
                      autoCapitalize="none"
                    />
                  </View>

                  <View style={styles.stepNavRow}>
                    <TouchableOpacity style={styles.backBtn} onPress={() => setAdmissionStep('payment')}>
                      <Text style={styles.backBtnText}>← Back</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={[styles.submitButton, admissionLoading && styles.loginButtonDisabled]}
                      onPress={handleAdmissionSubmit}
                      disabled={admissionLoading}
                      activeOpacity={0.85}
                    >
                      {admissionLoading ? (
                        <ActivityIndicator color={colors.white} />
                      ) : (
                        <Text style={styles.submitButtonText}>Submit Application</Text>
                      )}
                    </TouchableOpacity>
                  </View>
                </View>
              )}

              {admissionStep === 'submitted' && (
                <View style={styles.successBox}>
                  <View style={styles.successIconWrap}>
                    <Text style={styles.successIcon}>✓</Text>
                  </View>
                  <Text style={styles.successText}>
                    Application submitted successfully!
                  </Text>
                  <Text style={styles.successSubtext}>
                    Your application has been received. The school's admissions office will review it.\n\nUse "Check Admission Status" to track your application progress.
                  </Text>
                  <TouchableOpacity
                    style={[styles.searchButton, { marginTop: spacing.md }]}
                    onPress={() => { resetAdmissionFlow(); setShowStatusCheck(true); }}
                    activeOpacity={0.85}
                  >
                    <Text style={styles.searchButtonText}>Check Admission Status</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[styles.backBtn, { alignSelf: 'center', marginTop: spacing.sm }]}
                    onPress={resetAdmissionFlow}
                  >
                    <Text style={styles.backBtnText}>← Back to Login</Text>
                  </TouchableOpacity>
                </View>
              )}
            </View>
          </View>
        ) : showStatusCheck ? (
          <View style={styles.glassCard}>
            <View style={[styles.cardHeaderAccent, { backgroundColor: colors.info }]} />
            <TouchableOpacity
              style={styles.expandButton}
              onPress={resetStatusFlow}
              activeOpacity={0.85}
            >
              <View style={styles.expandButtonLeft}>
                <View style={[styles.panelIconWrap, { backgroundColor: colors.info + '20' }]}>
                  <Text style={[styles.panelIconText, { color: colors.info }]}>🔍</Text>
                </View>
                <View>
                  <Text style={styles.expandButtonTitle}>Check Admission Status</Text>
                  <Text style={styles.expandButtonSubtitle}>Track your application progress</Text>
                </View>
              </View>
              <Text style={styles.chevron}>▴</Text>
            </TouchableOpacity>

            <View style={styles.formBody}>
              {statusStep === 'lookup' && (
                <View>
                  <Text style={styles.label}>Applicant Full Name</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="Enter ward's name"
                      placeholderTextColor={colors.textLight}
                      value={statusName}
                      onChangeText={setStatusName}
                    />
                  </View>

                  <Text style={styles.label}>CSSPS Placement Reference</Text>
                  <View style={styles.inputWrap}>
                    <TextInput
                      style={styles.input}
                      placeholder="e.g. CSSPS/2026/0451"
                      placeholderTextColor={colors.textLight}
                      value={statusRef}
                      onChangeText={setStatusRef}
                      autoCapitalize="none"
                    />
                  </View>

                  <TouchableOpacity
                    style={styles.searchButton}
                    onPress={handleStatusCheck}
                    activeOpacity={0.85}
                  >
                    <Text style={styles.searchButtonText}>Check Status</Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={[styles.backBtn, { alignSelf: 'center', marginTop: spacing.sm }]}
                    onPress={() => { setShowStatusCheck(false); setShowAdmissionForm(true); }}
                  >
                    <Text style={styles.backBtnText}>← Back to Apply</Text>
                  </TouchableOpacity>
                </View>
              )}

              {statusStep === 'result' && statusResult && (
                <View>
                  {statusResult.credentialsExpired ? (
                    <View style={styles.deniedBox}>
                      <View style={styles.deniedIconWrap}>
                        <Text style={styles.deniedIcon}>✕</Text>
                      </View>
                      <Text style={styles.deniedTitle}>Application Denied</Text>
                      <Text style={styles.deniedText}>
                        We're sorry, your application has been rejected. Your credentials have expired. Please contact the school's admissions office for more information.
                      </Text>
                    </View>
                  ) : statusResult.status === 'Approved' ? (
                    <View>
                      <View style={styles.successBox}>
                        <View style={styles.successIconWrap}>
                          <Text style={styles.successIcon}>✓</Text>
                        </View>
                        <Text style={styles.successText}>Admission Approved!</Text>
                        <Text style={styles.successSubtext}>
                          Congratulations! Your ward has been admitted.\n\nProgramme: {statusResult.programme}\nStatus: {statusResult.status}\nDate Applied: {statusResult.dateApplied}
                        </Text>
                      </View>

                      {(() => {
                        const parentAcct = registryStore.getParentAccountByAdmission(statusResult.id);
                        if (parentAcct) {
                          return (
                            <View style={styles.credentialsBox}>
                              <Text style={styles.credentialsTitle}>Your Parent Account</Text>
                              <Text style={styles.credentialsDetail}>Username: {parentAcct.username}</Text>
                              <Text style={styles.credentialsDetail}>Password: {parentAcct.password}</Text>
                              <Text style={styles.credentialsHint}>Use these credentials to sign in to the Parent Portal.</Text>
                            </View>
                          );
                        }
                        return null;
                      })()}

                      {(() => {
                        const prospectusList = registryStore.getProspectusForParent(
                          registryStore.getParentAccountByAdmission(statusResult.id)?.username || ''
                        );
                        if (prospectusList.length > 0) {
                          return (
                            <View>
                              <Text style={styles.stepTitle}>Prospectus Available</Text>
                              {prospectusList.map((p: any) => (
                                <View key={p.id} style={styles.prospectusCard}>
                                  <Text style={styles.prospectusTitle}>{p.title}</Text>
                                  <Text style={styles.prospectusMeta}>{p.academicYear}</Text>
                                  <Text style={styles.prospectusPreview} numberOfLines={3}>{p.content}</Text>
                                  <TouchableOpacity
                                    style={styles.downloadBtn}
                                    onPress={() => {
                                      const printWindow = window.open('', '_blank');
                                      if (printWindow) {
                                        printWindow.document.write(`<html><head><meta charset='utf-8'><style>body{font-family:Arial,sans-serif;margin:40px;color:#1A1A2E;}h1{color:#0F4C75;border-bottom:2px solid #0F4C75;padding-bottom:8px;}pre{white-space:pre-wrap;font-size:14px;line-height:1.6;}</style></head><body><h1>${p.title}</h1><p style='color:#5C6370;font-size:12px;'>Academic Year: ${p.academicYear} | Published: ${p.datePublished}</p><pre>${p.content}</pre></body></html>`);
                                        printWindow.document.close();
                                        printWindow.focus();
                                        setTimeout(() => printWindow.print(), 500);
                                      }
                                    }}
                                  >
                                    <Text style={styles.downloadBtnText}>⬇ Download / Print Prospectus</Text>
                                  </TouchableOpacity>
                                </View>
                              ))}
                            </View>
                          );
                        }
                        return (
                          <Text style={styles.hintText}>No prospectus published yet. Check back later.</Text>
                        );
                      })()}
                    </View>
                  ) : (
                    <View style={styles.pendingBox}>
                      <View style={styles.pendingIconWrap}>
                        <Text style={styles.pendingIcon}>⏳</Text>
                      </View>
                      <Text style={styles.pendingTitle}>Application {statusResult.status}</Text>
                      <Text style={styles.pendingText}>
                        Applicant: {statusResult.applicantName}\nProgramme: {statusResult.programme}\nDate Applied: {statusResult.dateApplied}\n\nYour application is being reviewed. Please check back later for updates.
                      </Text>
                      {statusResult.fee && statusResult.fee.status === 'Unpaid' && (
                        <Text style={styles.feeWarning}>⚠ Application fee is unpaid. Please complete payment.</Text>
                      )}
                    </View>
                  )}

                  <TouchableOpacity
                    style={[styles.backBtn, { alignSelf: 'center', marginTop: spacing.md }]}
                    onPress={() => setStatusStep('lookup')}
                  >
                    <Text style={styles.backBtnText}>← Check Another</Text>
                  </TouchableOpacity>
                </View>
              )}
            </View>
          </View>
        ) : (
          <View style={styles.collapsedWrap}>
            <Animated.Image
              source={{ uri: PANEL_BG_IMAGES[admissionBgIndex] }}
              style={styles.collapsedBgImage}
              resizeMode="cover"
            />
            <View style={[styles.collapsedBgOverlay, { backgroundColor: colors.primaryDark + '80' }]} />
            <TouchableOpacity
              style={[styles.collapsedButton, { borderColor: colors.accent + '66', backgroundColor: 'transparent' }]}
              onPress={() => setShowAdmissionForm(true)}
              activeOpacity={0.85}
            >
              <View style={styles.collapsedButtonLeft}>
                <View style={[styles.collapsedIconWrap, { backgroundColor: colors.accent + '20' }]}>
                  <Text style={[styles.collapsedIconText, { color: colors.accent }]}>✎
                  </Text>
                </View>
                <View>
                  <Text style={styles.collapsedTitle}>Apply for Admission</Text>
                  <Text style={styles.collapsedSubtitle}>New student? Search for placement.</Text>
                </View>
              </View>
              <Text style={styles.collapsedChevron}>▾</Text>
            </TouchableOpacity>
          </View>
        )}

        {/* ── COLUMN 3: Info Carousel ── Animated slideshow with school images */}
        <View style={styles.infoColumn}>
          <Animated.View
            style={[
              styles.infoSlide,
              { opacity: fadeAnim, transform: [{ translateY: slideAnim }] },
            ]}
          >
            <Image
              source={{ uri: INFO_SLIDES[slideIndex].image }}
              style={styles.infoImage}
              resizeMode="cover"
            />
            <View style={styles.infoImageOverlay} />
            <View style={styles.infoTextOverlay}>
              <View style={[styles.infoAccentBar, { backgroundColor: INFO_SLIDES[slideIndex].accent }]} />
              <Text style={styles.infoTitle}>{INFO_SLIDES[slideIndex].title}</Text>
              <Text style={styles.infoText}>{INFO_SLIDES[slideIndex].text}</Text>
            </View>
          </Animated.View>

          <View style={styles.infoDots}>
            {INFO_SLIDES.map((_, i) => (
              <View
                key={i}
                style={[
                  styles.infoDot,
                  i === slideIndex && styles.infoDotActive,
                  i === slideIndex && { backgroundColor: INFO_SLIDES[slideIndex].accent },
                ]}
              />
            ))}
          </View>
        </View>
      </View>

      {/* ── FOOTER ── Fixed minimal bar with top border */}
      <View style={styles.footer}>
        <Text style={styles.footerText}>
          © 2026 Ghana SHS SIMS  ·  v0.1.0
        </Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.primaryDark,
  },
  // ── Header ──
  header: {
    height: HEADER_HEIGHT,
    width: '100%',
    position: 'relative',
    backgroundColor: colors.primaryDark,
    overflow: 'hidden',
  },
  headerImage: {
    width: '100%',
    height: '100%',
  },
  headerOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.overlay,
  },
  headerBrand: {
    position: 'absolute',
    bottom: spacing.xl,
    left: 0,
    right: 0,
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
  },
  logoRing: {
    width: 64,
    height: 64,
    borderRadius: 32,
    borderWidth: 2,
    borderColor: colors.accent,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  logoInner: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: colors.accent,
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoText: {
    fontSize: fontSize.xs,
    fontWeight: fontWeight.extrabold,
    color: colors.primaryDark,
    letterSpacing: 1,
  },
  brandTitle: {
    fontSize: fontSize.xl,
    fontWeight: fontWeight.bold,
    color: colors.white,
    textAlign: 'center',
    lineHeight: fontSize.xl * 1.3,
    marginBottom: spacing.xs,
  },
  brandTagline: {
    fontSize: fontSize.sm,
    color: colors.accent,
    fontWeight: fontWeight.medium,
    textAlign: 'center',
    letterSpacing: 0.5,
  },
  // ── Body ──
  body: {
    flex: 1,
    flexDirection: 'row',
    backgroundColor: colors.primaryDark,
    paddingHorizontal: spacing.xl,
    paddingBottom: spacing.lg,
    gap: spacing.lg,
    marginTop: -30,
  },
  glassCard: {
    flex: 1,
    maxWidth: 480,
    backgroundColor: colors.glassLight,
    borderRadius: radius.xl,
    padding: spacing.md,
    ...shadows.xl,
    borderWidth: 1,
    borderColor: colors.glassBorder,
    overflow: 'hidden',
  },
  panelBgImage: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: '100%',
    height: '100%',
  },
  panelBgOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.primaryDark,
  },
  cardHeaderAccent: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    height: 4,
    backgroundColor: colors.primaryLight,
  },
  expandButton: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  collapsedWrap: {
    flex: 1,
    maxWidth: 480,
    borderRadius: radius.lg,
    overflow: 'hidden',
    position: 'relative',
    ...shadows.md,
  },
  collapsedBgImage: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: '100%',
    height: '100%',
  },
  collapsedBgOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.primaryDark + '80',
  },
  collapsedButton: {
    flex: 1,
    maxWidth: 480,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.md + 2,
    paddingHorizontal: spacing.lg,
    borderRadius: radius.lg,
    borderWidth: 1.5,
    borderStyle: 'dashed',
    borderColor: colors.primaryLight + '66',
    backgroundColor: 'transparent',
  },
  collapsedButtonLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  collapsedIconWrap: {
    width: 48,
    height: 48,
    borderRadius: 14,
    backgroundColor: colors.primaryLight + '40',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
    borderWidth: 1,
    borderColor: colors.primaryLight + '4D',
  },
  collapsedIconText: {
    fontSize: 22,
    fontWeight: fontWeight.extrabold,
    color: colors.primaryLight,
  },
  collapsedTitle: {
    fontSize: fontSize.lg,
    fontWeight: fontWeight.extrabold,
    color: colors.white,
    letterSpacing: 0.3,
    textShadowColor: colors.primaryDark,
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 4,
  },
  collapsedSubtitle: {
    fontSize: fontSize.xs,
    color: colors.white + 'CC',
    marginTop: 3,
    letterSpacing: 0.2,
    fontWeight: fontWeight.semibold,
    textShadowColor: colors.primaryDark,
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  collapsedChevron: {
    fontSize: 18,
    color: colors.white + '99',
    fontWeight: fontWeight.extrabold,
  },
  expandButtonLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  expandButtonTitle: {
    fontSize: fontSize.lg,
    fontWeight: fontWeight.bold,
    color: colors.text,
  },
  expandButtonSubtitle: {
    fontSize: fontSize.xs,
    color: colors.textSecondary,
    marginTop: 2,
  },
  chevron: {
    fontSize: fontSize.md,
    color: colors.textLight,
    fontWeight: fontWeight.bold,
  },
  formBody: {
    marginTop: spacing.md,
    paddingTop: spacing.md,
    borderTopWidth: 1.5,
    borderTopColor: colors.borderLight,
    maxHeight: 420,
  },
  formBodyContent: {
    paddingBottom: spacing.md,
  },
  panelIconWrap: {
    width: 48,
    height: 48,
    borderRadius: 14,
    backgroundColor: colors.infoBg,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  panelIconText: {
    fontSize: 22,
    fontWeight: fontWeight.bold,
    color: colors.primary,
  },
  sectionTitle: {
    fontSize: fontSize.xl,
    fontWeight: fontWeight.bold,
    color: colors.text,
    marginBottom: 2,
  },
  sectionSubtitle: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    marginBottom: 0,
  },
  label: {
    fontSize: fontSize.sm,
    fontWeight: fontWeight.semibold,
    color: colors.textSecondary,
    marginBottom: spacing.xs,
    marginTop: spacing.md,
    letterSpacing: 0.3,
  },
  inputWrap: {
    marginBottom: spacing.sm,
  },
  input: {
    borderWidth: 1.5,
    borderColor: colors.border,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm + 4,
    fontSize: fontSize.md,
    color: colors.text,
    backgroundColor: colors.surface,
    ...shadows.sm,
  },
  loginButton: {
    backgroundColor: colors.primary,
    borderRadius: radius.md,
    paddingVertical: spacing.md,
    alignItems: 'center',
    marginTop: spacing.md,
    flexDirection: 'row',
    justifyContent: 'center',
    gap: spacing.sm,
    ...shadows.glow,
  },
  loginButtonDisabled: {
    opacity: 0.6,
  },
  loginButtonText: {
    color: colors.white,
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
    letterSpacing: 0.5,
  },
  loginButtonArrow: {
    color: colors.accent,
    fontSize: fontSize.lg,
    fontWeight: fontWeight.bold,
  },
  forgotLink: {
    alignItems: 'center',
    marginTop: spacing.md,
  },
  forgotPassword: {
    color: colors.primaryLight,
    fontSize: fontSize.sm,
    fontWeight: fontWeight.medium,
  },
  demoDivider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: spacing.md,
  },
  demoDividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: colors.border,
  },
  demoDividerText: {
    fontSize: fontSize.xs,
    color: colors.textLight,
    fontWeight: fontWeight.medium,
    paddingHorizontal: spacing.sm,
  },
  demoButton: {
    backgroundColor: colors.primaryDark,
    borderRadius: radius.md,
    paddingVertical: spacing.sm + 4,
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: colors.accent + '66',
  },
  demoButtonText: {
    color: colors.accent,
    fontSize: fontSize.sm,
    fontWeight: fontWeight.bold,
    letterSpacing: 0.3,
  },
  errorBox: {
    backgroundColor: colors.dangerBg,
    borderRadius: radius.md,
    padding: spacing.sm + 2,
    marginBottom: spacing.md,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    borderWidth: 1,
    borderColor: colors.danger + '30',
  },
  errorIconWrap: {
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: colors.danger,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorIcon: {
    color: colors.white,
    fontSize: fontSize.sm,
    fontWeight: fontWeight.bold,
  },
  errorText: {
    color: colors.danger,
    fontSize: fontSize.sm,
    flex: 1,
    fontWeight: fontWeight.medium,
  },
  errorDismissBtn: {
    padding: spacing.xs,
  },
  errorDismiss: {
    color: colors.danger,
    fontSize: fontSize.sm,
    fontWeight: fontWeight.bold,
  },
  searchButton: {
    backgroundColor: colors.surface,
    borderRadius: radius.md,
    paddingVertical: spacing.sm + 4,
    alignItems: 'center',
    borderWidth: 2,
    borderColor: colors.primaryLight,
    marginTop: spacing.xs,
  },
  searchButtonText: {
    color: colors.primaryLight,
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
  },
  admissionForm: {
    marginTop: spacing.md,
    paddingTop: spacing.md,
    borderTopWidth: 1.5,
    borderTopColor: colors.borderLight,
  },
  matchBanner: {
    backgroundColor: colors.successBg,
    borderRadius: radius.md,
    padding: spacing.sm + 2,
    marginBottom: spacing.md,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    borderWidth: 1,
    borderColor: colors.success + '25',
  },
  matchIconWrap: {
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: colors.success,
    justifyContent: 'center',
    alignItems: 'center',
  },
  matchIcon: {
    color: colors.white,
    fontSize: fontSize.xs,
    fontWeight: fontWeight.bold,
  },
  matchText: {
    fontSize: fontSize.sm,
    color: colors.success,
    fontWeight: fontWeight.medium,
    flex: 1,
  },
  submitButton: {
    backgroundColor: colors.accent,
    borderRadius: radius.md,
    paddingVertical: spacing.md,
    alignItems: 'center',
    marginTop: spacing.md,
    ...shadows.glow,
  },
  submitButtonText: {
    color: colors.primaryDark,
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
  },
  successBox: {
    backgroundColor: colors.successBg,
    borderRadius: radius.lg,
    padding: spacing.xl,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.success + '25',
  },
  successIconWrap: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: colors.success,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
    ...shadows.md,
  },
  successIcon: {
    fontSize: fontSize.xxl,
    color: colors.white,
    fontWeight: fontWeight.bold,
  },
  successText: {
    fontSize: fontSize.lg,
    fontWeight: fontWeight.bold,
    color: colors.success,
    textAlign: 'center',
    marginBottom: spacing.xs,
  },
  successSubtext: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: fontSize.sm * 1.5,
  },
  // ── Footer ──
  footer: {
    height: 48,
    borderTopWidth: 1,
    borderTopColor: colors.white + '1F',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.primaryDark,
  },
  footerText: {
    fontSize: fontSize.xs,
    color: colors.white + '66',
    letterSpacing: 0.5,
  },
  // ── Info Carousel (3rd column) ──
  infoColumn: {
    flex: 1,
    maxWidth: 480,
  },
  infoSlide: {
    flex: 1,
    borderRadius: radius.lg,
    overflow: 'hidden',
    position: 'relative',
    ...shadows.md,
    backgroundColor: colors.primaryDark,
  },
  infoImage: {
    width: '100%',
    height: '100%',
    position: 'absolute',
    top: 0,
    left: 0,
  },
  infoImageOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.primaryDark + 'A6',
  },
  infoTextOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: spacing.lg,
  },
  infoAccentBar: {
    width: 32,
    height: 3,
    borderRadius: 2,
    marginBottom: spacing.sm,
  },
  infoTitle: {
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
    color: colors.white,
    marginBottom: 4,
    letterSpacing: 0.3,
  },
  infoText: {
    fontSize: fontSize.xs,
    color: colors.white + 'B3',
    lineHeight: fontSize.xs * 1.5,
  },
  infoDots: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: spacing.sm,
    gap: 6,
  },
  infoDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: colors.white + '33',
  },
  infoDotActive: {
    width: 20,
    borderRadius: 4,
  },
  // ── Admission flow styles ──
  stepTitle: {
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
    color: colors.text,
    marginTop: spacing.md,
    marginBottom: spacing.xs,
  },
  stepSubtitle: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    marginBottom: spacing.sm,
  },
  paymentMethodRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    marginBottom: spacing.sm,
  },
  paymentMethodCard: {
    flex: 1,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radius.md,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.sm,
    alignItems: 'center',
    borderWidth: 2,
    borderColor: 'transparent',
  },
  paymentMethodActive: {
    borderColor: colors.accent,
    backgroundColor: colors.accent + '15',
  },
  paymentMethodIcon: {
    fontSize: fontSize.xl,
    marginBottom: spacing.xs,
  },
  paymentMethodLabel: {
    fontSize: fontSize.sm,
    fontWeight: fontWeight.semibold,
    color: colors.text,
  },
  stepNavRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: spacing.md,
    gap: spacing.sm,
  },
  backBtn: {
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
  },
  backBtnText: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    fontWeight: fontWeight.medium,
  },
  privacyNotice: {
    fontSize: fontSize.xs,
    color: colors.textSecondary,
    marginVertical: spacing.sm,
    lineHeight: 16,
  },
  hintText: {
    fontSize: fontSize.xs,
    color: colors.textLight,
    fontStyle: 'italic',
    marginTop: spacing.xs,
  },
  deniedBox: {
    backgroundColor: colors.danger + '15',
    borderRadius: radius.lg,
    padding: spacing.lg,
    alignItems: 'center',
  },
  deniedIconWrap: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: colors.danger,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  deniedIcon: {
    fontSize: fontSize.xl,
    color: colors.white,
    fontWeight: fontWeight.bold,
  },
  deniedTitle: {
    fontSize: fontSize.lg,
    fontWeight: fontWeight.bold,
    color: colors.danger,
    marginBottom: spacing.sm,
  },
  deniedText: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: fontSize.sm * 1.5,
  },
  pendingBox: {
    backgroundColor: colors.warning + '15',
    borderRadius: radius.lg,
    padding: spacing.lg,
    alignItems: 'center',
  },
  pendingIconWrap: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: colors.warning,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  pendingIcon: {
    fontSize: fontSize.xl,
  },
  pendingTitle: {
    fontSize: fontSize.lg,
    fontWeight: fontWeight.bold,
    color: colors.warning,
    marginBottom: spacing.sm,
  },
  pendingText: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: fontSize.sm * 1.5,
  },
  feeWarning: {
    fontSize: fontSize.sm,
    color: colors.danger,
    fontWeight: fontWeight.semibold,
    marginTop: spacing.sm,
  },
  credentialsBox: {
    backgroundColor: colors.info + '15',
    borderRadius: radius.md,
    padding: spacing.md,
    marginTop: spacing.md,
  },
  credentialsTitle: {
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
    color: colors.info,
    marginBottom: spacing.xs,
  },
  credentialsDetail: {
    fontSize: fontSize.sm,
    color: colors.text,
    marginTop: spacing.xs,
  },
  credentialsHint: {
    fontSize: fontSize.xs,
    color: colors.textLight,
    fontStyle: 'italic',
    marginTop: spacing.sm,
  },
  prospectusCard: {
    backgroundColor: colors.surfaceAlt,
    borderRadius: radius.md,
    padding: spacing.md,
    marginTop: spacing.sm,
    borderWidth: 1,
    borderColor: colors.border,
  },
  prospectusTitle: {
    fontSize: fontSize.md,
    fontWeight: fontWeight.bold,
    color: colors.text,
  },
  prospectusMeta: {
    fontSize: fontSize.xs,
    color: colors.textSecondary,
    marginTop: 2,
  },
  prospectusPreview: {
    fontSize: fontSize.sm,
    color: colors.textSecondary,
    marginTop: spacing.xs,
    lineHeight: fontSize.sm * 1.4,
  },
  downloadBtn: {
    backgroundColor: colors.primary,
    borderRadius: radius.md,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    marginTop: spacing.sm,
    alignSelf: 'flex-start',
  },
  downloadBtnText: {
    color: colors.white,
    fontSize: fontSize.sm,
    fontWeight: fontWeight.semibold,
  },
});
