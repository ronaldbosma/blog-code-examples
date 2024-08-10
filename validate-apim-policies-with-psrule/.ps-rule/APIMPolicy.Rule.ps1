<#
    This file contains PSRule rules that can be used to validate Azure API Management policy files.
#>


# Synopsis: The first policy inside the inbound section should be the base policy to make sure important logic like security checks are applied first.
Rule "APIMPolicy.Rules.InboundBasePolicy" -If { $TargetObject.Level -ne "Global" -and $TargetObject.Level -ne "Fragment" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    $Assert.HasField($policy.inbound, "base")
    $Assert.HasFieldValue($policy, "inbound.FirstChild.Name", "base")
}

# Synopsis: The backend section should only have the base policy to make sure the request is forwarded, and because only one policy is allowed.
Rule "APIMPolicy.Rules.BackendBasePolicy" -If { $TargetObject.Level -ne "Global" -and $TargetObject.Level -ne "Fragment" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "backend")
    $Assert.HasField($policy.backend, "base")
    $Assert.HasFieldValue($policy, "backend.ChildNodes.Count", 1)
}

# Synopsis: The outbound section should include the base policy so generic logic like error handling can be applied.
Rule "APIMPolicy.Rules.OutboundBasePolicy" -If { $TargetObject.Level -ne "Global" -and $TargetObject.Level -ne "Fragment" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "outbound")
    $Assert.HasField($policy.outbound, "base")
}

# Synopsis: The on-error section should include the base policy so generic logic like error handling can be applied.
Rule "APIMPolicy.Rules.OnErrorBasePolicy" -If { $TargetObject.Level -ne "Global" -and $TargetObject.Level -ne "Fragment" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "on-error")
    $Assert.HasField($policy."on-error", "base")
}

# Synopsis: The backend section in the global policy should only have the forward-request policy to make sure the request is forwarded, and because only one policy is allowed.
Rule "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy" -If { $TargetObject.Level -eq "Global" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "backend")
    $Assert.HasField($policy.backend, "forward-request")
    $Assert.HasFieldValue($policy, "backend.ChildNodes.Count", 1)
}

# Synopsis: A set-backend-service policy should use a backend entity (by setting the backend-id attribute) so it's reusable and easier to maintain.
Rule "APIMPolicy.Rules.UseBackendEntity" `
    -If { $TargetObject.Content.DocumentElement.SelectNodes(".//*[local-name()='set-backend-service']").Count -ne 0  } `
    -Type "APIMPolicy" `
{
    $policy = $TargetObject.Content.DocumentElement

    # Select all set-backend-service policies
    $setBackendServicePolicies = $policy.SelectNodes(".//*[local-name()='set-backend-service']")

    # Check that each set-backend-service policy has the backend-id attribute set
    foreach ($setBackendServicePolicy in $setBackendServicePolicies) {
        $Assert.HasField($setBackendServicePolicy, "backend-id")
    }
}

# Synopsis: The subscription key header (Ocp-Apim-Subscription-Key) should be removed in the inbound section of the global policy to prevent it from being forwarded to the backend.
Rule "APIMPolicy.Rules.RemoveSubscriptionKeyHeader" -If { $TargetObject.Level -eq "Global" } -Type "APIMPolicy" {
    $policy = $TargetObject.Content.DocumentElement
    
    $Assert.HasField($policy, "inbound")
    
    # Select all set-header policies that remove the Ocp-Apim-Subscription-Key header.
    # We only check direct children of the inbound section, because the header should always be removed and not optionally (e.g. when it's nested in a choose.when).
    # The expression is surround by @(...) because the result is a XmlElement if only one occurence is found, but we want an array.
    $removeSubscriptionKeyPolicies = @( $policy.inbound.ChildNodes | Where-Object { 
        $_.LocalName -eq "set-header" -and 
        $_.name -eq "Ocp-Apim-Subscription-Key" -and 
        $_."exists-action" -eq "delete" 
    } )

    if ($removeSubscriptionKeyPolicies.Count -gt 0) {
        $Assert.Pass()
    } else {
        $Assert.Fail("Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section.")
    }
}