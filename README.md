# Internship-Reviewer-App (INTERNOVA)
This project is a mobile application developed using Flutter, designed to help students review and rate their internship experiences. The app allows users to provide feedback on various aspects of their internships, including company environment, mentorship, and skill development.

# Group Details
### Group Name: Triple-A 

|                    Name                   |    Matric Number     |                                          Tasks                                                                             |
|-------------------------------------------|----------------------|----------------------------------------------------------------------------------------------------------------------------|                                 
|      MOHAMAD AIMAN AKIM BIN ADANAN        |       2113823        |             Complete the title, background problem, app compatibility screen navigation flow, Gantt chart, and references  |
|            MUHAMMAD BIN ABAS              |       2113201        |                        Complete the objective, target user, sequence diagram, and references                               |
|       ARIF MUQRI BIN AHMAD NAZIRI         |       2113825        |             Complete the preferred platform, features/functionalities, technical feasibility, and references               |


# Case Study 1
## Project Initiation

**1. Title:**
Internship Reviewer Application (INTERNOVA)

**2. Background of the problem** 

- Interns often don’t receive consistent or organized feedback on their performance.
- Interns lack clear channels to communicate with mentors or supervisors.
- Internship assessments vary widely, leading to unfair evaluations.
- It’s difficult for both interns and employers to track progress and achievements during the internship.

**3. Purpose or objective**

The purpose of INTERNOVA is to improve the internship experience for both interns and employers by:  

1. **Providing Clear Feedback:**  
   Supervisors can fill out simple feedback forms to give interns structured information about their strengths and areas for improvement.  

2. **Enhancing Communication:**  
   Interns can use built-in messaging tools to send questions or updates directly to their supervisors.  

3. **Ensuring Fair Reviews:**  
   A standardized evaluation system is used for all interns to ensure consistency and fairness in assessments.  

4. **Tracking Progress:**  
   A progress dashboard helps interns and employers monitor completed tasks, achievements, and skill development in real-time.  

---

### Example Scenario  

An intern submits a project through the platform. 

The supervisor:  
- Completes an evaluation form with comments and a score.  
- Sends feedback directly to the intern.  

The intern:  
- Views the feedback on their dashboard.  
- Replies with questions or clarifications through the messaging feature.  
- Check their progress on a visual chart.  

Both parties stay updated and aligned on the intern's performance and goals throughout the internship.  

---

**4. Target user** 

The **INTERNOVA** platform is designed for the following groups:  

1. **Interns:**  
   - Receive structured feedback and track progress.  
   - Communicate effectively with mentors or supervisors.  
   - Understand strengths, weaknesses, and areas for improvement.  

2. **Supervisors and Mentors:**  
   - Provide consistent and fair evaluations using standardized templates.  
   - Track intern performance and communicate through a centralized platform.  

3. **HR Teams or Internship Coordinators:**  
   - Oversee the progress and performance of all interns.  
   - Ensure evaluations are fair, consistent, and aligned with organizational policies.  

4. **Employers or Organizations:**  
   - Streamline the internship evaluation process and enhance the overall experience.  
   - Identify high-performing interns for potential future opportunities.
</br>

**5. Preferred platform** </br>
With Firebase serving as the back-end, Internova will use Flutter for cross-platform development with an eye towards Android. This strategy complies with market trends for affordable, high-performing mobile solutions while guaranteeing accessibility for students and young professionals. It has responsive features like document sharing, progress monitoring, and real-time feedback and is portable.
</br></br>

**6. Features and functionalities** 

📲 *Authentication:*
- User login and registration with Firebase Authentication (supporting email, Google, or social logins).
- Secure authentication flow with email verification and password reset options.

📲 *User Profiles:*
- Profile creation and editing for interns and employers, stored in Firebase Firestore.
- Fields for interns' skills, interests, and past internship experiences; employer-specific details for companies.

📲 *Internship Details and Logs:*
- View detailed internship descriptions, requirements, and mentor details fetched from Firestore.
- A progress log for interns to add daily or weekly updates, with timestamps and supervisor comments.

📲 *Feedback Page:*
- Structured feedback templates for mentors and peers.
- Real-time updates using Firebase Real-time Database or Firestore.
- Option for anonymous feedback submission to encourage honest input.

📲 *Notifications:*
- In-app and push notifications using Firebase Cloud Messaging (FCM) for new feedback, updates on logs, and reminders for document uploads.

📲 *Document Upload and Sharing:*
- Upload resumes, reports, or certificates directly to Firebase Storage.
- Share documents with mentors or employers via in-app links or external sharing options.

---

## Requirement Analysis

**1. Technical Feasibility/Back-End Assessments** 

🔖 *Platform:*
- Flutter: Enables rapid development with reusable widgets, ensuring consistent UI across Android devices.

🔖 *Back-end and Infrastructure:*
- Firebase Authentication: Simplifies user login/registration workflows.
- Firebase Firestore: Serves as the primary database for storing user profiles, logs, internship details, and feedback.
- Firebase Storage: Manages document uploads and sharing securely.
- Firebase Cloud Messaging (FCM): Handles push notifications for engagement.


**2. App Compatibility** 

🎯 *Operating System Compatibility*
- Minimum Android Version: Android 8.0 (Oreo) and above.
- The app will be optimized for the most common Android versions to ensure maximum reach among users.

🎯 *Device Compatibility*
- Smartphones and Tablets

🎯 *Hardware Compatibility*
- Touchscreen: The app will be designed with touchscreen optimization, supporting taps, swipes, and gestures for easy navigation.

🎯 *Firebase Backend Compatibility*
- Firebase Authentication: Seamlessly integrates with Android’s native authentication methods.
- Firebase Firestore: Optimized for fast, real-time data sync for feedback, internship logs, and notifications.
- Firebase Storage: Supports document uploads and sharing via Firebase Cloud Storage for resumes, reports, and certificates.
- Firebase Cloud Messaging (FCM): Sending push notifications directly to Android devices, ensuring real-time alerts for feedback, log updates, and reminders.

🎯 *App Updates Compatibility*
- Regular Updates: The app will be updated regularly to stay compatible with new Android versions, ensuring long-term support for future Android OS releases.


**3. Sequence Diagram**

<img src="Sequence Diagram.png" alt="Sequence Diagram" width="1000" height="1800">


**4. Screen Navigation Flow**

<img src="Screen Navigation Flow.png" alt="Screen Navigation Flow" width="1000" height="700">

---

## Planning

**Gantt Chart**

<img src="Internova Gantt Chart1.png" alt="Gantt Chart" width="1000" height="700">

---

## References

i) GradLeaders. (n.d.). Top 10 Internship Challenges Employers Face Today and the #1 Solution to Recruiting, Managing, and Converting Interns. Retrieved from https://www.gradleaders.com/top-10-internship-challenges-employers-face-today-and-the-1-solution-to-recruiting-managing-and-converting-interns-2/

ii) Betternship. (2024). Effective Internship Evaluation Strategies in 2024. Retrieved from https://www.betternship.com/effective-internship-evaluation-strategies-in-2024/

iii) National Association of Colleges and Employers (NACE). (n.d.). 15 Best Practices for Internship Programs. Retrieved from https://www.naceweb.org/talent-acquisition/internships/15-best-practices-for-internship-programs/

iv) Firouzeh Moeinzadeh, Sayed, Bijan Iraj, Mortazavi, M., & Vajiheh Vafamehr. (2021). Designing, implementation, and evaluation of internship comprehensive system for assessment and monitoring. Journal of Education and Health Promotion, 10(1), 93–93. https://doi.org/10.4103/jehp.jehp_626_20

v) InternBridge. (n.d.). Internship Program Best Practices: Creating a High-Impact Internship Program. Retrieved December 23, 2024, from https://internbridge.com

vi) Google. (2024). Flutter Documentation. Retrieved December 23, 2024, from https://flutter.dev/docs

vii) Firebase. (n.d.). Firebase Documentation. Google. Retrieved December 23, 2024, from https://firebase.google.com/docs

viii) Google. (2024). Android Developers: Compatibility and Support. Retrieved December 23, 2024, from https://developer.android.com/guide


