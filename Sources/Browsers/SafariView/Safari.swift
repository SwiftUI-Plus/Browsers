import SafariServices

public typealias DismissHandler = () -> Void

#if os(iOS)

/// Represents a Safari configuration
public struct Safari {

    public typealias ActivitiesHandler = (_ url: URL, _ title: String?) -> [UIActivity]
    public typealias ExcludedActivitiesHandler = (_ url: URL, _ title: String?) -> [UIActivity.ActivityType]

    let configuration: SFSafariViewController.Configuration?
    let preferredBarTintColor: UIColor?
    let preferredControlTintColor: UIColor?
    let dismissButtonStyle: SFSafariViewController.DismissButtonStyle
    let activities: ActivitiesHandler?
    let excludedActivities: ExcludedActivitiesHandler?

    /// Makes a new Safari configuration
    /// - Parameters:
    ///   - configuration: The Safari controller configuration
    ///   - activities: If a user attempts to share an item from Safari, you can provide additionaal activities using this closure
    ///   - excludedActivities: If a user attempts to share an item from Safari, you can exclude specific activities using this closure
    ///   - preferredBarTintColor: The preferred Safari bar tint color to use during presentation
    ///   - preferredControlTintColor: The preferred Safari control's tint color to use during presentation
    ///   - dismissButtonStyle: The Safari dismiss button style to use during presentation
    public init(
        configuration: SFSafariViewController.Configuration? = nil,
        activities: ActivitiesHandler? = nil,
        excludedActivities: ExcludedActivitiesHandler? = nil,
        preferredBarTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done
    ) {
        self.configuration = configuration
        self.activities = activities
        self.excludedActivities = excludedActivities
        self.preferredBarTintColor = preferredBarTintColor
        self.preferredControlTintColor = preferredControlTintColor
        self.dismissButtonStyle = dismissButtonStyle
    }

}

#endif
